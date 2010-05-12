rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

'TODO: Tidy up and add ability to customise display style/colours
' Convert to use LUA instead of current method
Type TConsole Extends TGameService

	Const POSITION_TOP:Int = 1
	Const POSITION_BOTTOM:Int = 2

	Global instance:TConsole		' This holds the singleton instance of this Type

	Field isActive:Int = False	' Console active flag
	Field commands:TMap = New TMap		' Command map
	Field text:TList = New TList		' Active console text
	Field commandHistory:TList = New TList		' Command history
	Field width:Int
	Field lines:Int = 15		' Size
	Field currentLine:Int = 0		' Console list position
	Field inputField:String = ""
	Field cursorPosition:Int = 0

	Field bufferSize:Int = 1000
	
	Field padding:Int = 8
	
	Field font:TImageFont
	
	Field fgColour:TColourRGB = New TColourRGB
	Field bgColour:TColourRGB = New TColourRGB
	Field borderColour:TColourRGB = New TColourRGB
	
	' History pos
	Field historyPos:Int = -1
		
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TConsole()
		Return TConsole.GetInstance()		
	End Function
	
	Function GetInstance:TConsole()
		If Not instance
			Return New TConsole	
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		' Load ini file stuff here
		SetName("Console")
		
		'Add some default colours
		fgColour.r = 255
		fgColour.g = 255
		fgColour.b = 255
		fgColour.a = 0.8

		borderColour.r = 0
		borderColour.g = 0
		borderColour.b = 255
		borderColour.a = 0.6
		
		bgColour.r = 0
		bgColour.g = 0
		bgColour.b = 128
		bgColour.a = 0.6

		
		' Add built-in commands
		Self.AddCommand("list", "list - Lists all available commands.", cmdList)
		Self.AddCommand("help", "help - Lists all available commands.", cmdList)
		Self.AddCommand("clear", "clear - clears the console.", cmdClearConsole)
		Self.AddCommand("echo", "echo <text> - Echo text to console.", cmdEcho)
		Self.AddCommand("dump", "dump - Dumps console text to 'ConsoleDump.txt'.", cmdDump)
		Self.AddCommand("exec", "exec <filename> - Executes a console script file.", cmdExecFile)
		
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method

	
	' Update console
	Method DebugUpdate()
	
		' Check for console activation key
		If (KeyHit(KEY_TAB))
		
			isActive = Not isActive
			FlushKeys()
		
		End If
		
		' Do an input check
		CheckInput()
	
	End Method
	
	Method DebugRender()
		' Active?
		If (isActive)
		
			width = rrGetGraphicsWidth()
		
			Local fontHeight:Float = TextHeight("I")
				
			' Draw console
			bgColour.Set()
			DrawRect(0, 0, width, lines*fontHeight+(padding*2))
			
			borderColour.Set()
			DrawRect(0, 0, width, 2)
			DrawRect(0, 0, 2, lines*fontHeight+(padding*2))
			DrawRect(0, lines*fontHeight+(padding*2), width, 2)
			DrawRect(width-2, 0 , 2, lines*fontHeight+(padding*2))
			
			fgColour.Set()
			
			' Draw active console text
			Local printLine:Int=0
			Local endLine:Int = currentLine + lines - 2
			If endLine > text.Count()-1 Then endLine = text.Count()-1
			For Local i:Int = currentLine To endline
			
				DrawText(String(text.ValueAtIndex(i)), padding, padding+(fontheight*printLine))
				printLine:+1
			
			Next		
			
			' Draw input string
			DrawText(inputField, padding, padding+(fontheight*(lines-1)))

			' Draw cursor			
			DrawText("_", TextWidth(inputField[..cursorPosition+1])-2, padding+(fontheight*(lines-1)))			
			
			' Draw scroll markers?
			If (currentLine > 0)
			
				DrawText("<<", width-padding-(TextWidth("<<")), padding)
			
			End If
			If (currentLine + lines <= text.Count())
			
				DrawText(">>", width-padding-(TextWidth(">>")), (lines-1)*fontheight-padding)

			End If
		
		EndIf		
	
	End Method
	
	' Check input
	Method CheckInput()
	
		' Active?
		If (isActive)
		
			' Do passive scroll?
			If (KeyHit(KEY_PAGEUP))
				
				If (currentLine > 0)
					currentLine :- (lines - 2)
					If currentLine < 0 Then currentLine = 0
				End If			
			
			ElseIf (KeyHit(KEY_PAGEDOWN))
			
				If (currentLine <= (text.Count()-1)-(lines-1))
					currentLine :+ lines-1
					If currentLine > text.Count()-(lines-1) Then currentLine = text.Count()-(lines-1)
				End If	
			
			End If
			
			Local ch:Int = GetChar()
		
			If ((ch > 31) And (ch < 126))
				inputField=inputField[..cursorPosition]+Chr(ch)+inputField[cursorPosition..]':+Chr(ch)
				cursorPosition:+1
			EndIf
			
			Select (ch)
				Case 8 'Backspace
					If (cursorPosition > 0)
					
						inputField=inputField[..cursorPosition-1]+inputField[cursorPosition..] 'backspace
						cursorPosition:-1
						
					EndIf
				
				Case 13 'Return
					If (Len(inputField)>0)
					
						Local cmdList:TList = New TList.FromArray(inputField.Split(" "))
						Local args:String[] = New String[cmdList.Count()-1]
						Local cmd:String = String(cmdList.ValueAtIndex(0))
						
						If (cmdList.Count() > 1)
						
							For Local i%=1 To cmdList.Count()-1
							
								args[i-1] = String(cmdList.ValueAtIndex(i)).toLower()
							
							Next
							
						End If
						ExecuteCommand(cmd, args)
						commandHistory.AddFirst(inputField)						
						
					EndIf
					
					inputField = "" 'return
					cursorPosition = 0
					historyPos = -1
								
				Case 27 'Escape
				
					inputField = "" 'escape
					cursorPosition = 0	
					historyPos = -1				
					
			End Select
			
			' Check special keys
			Local SpecialKey% = GetKey()
			
			Select (SpecialKey)
			
				Case KEY_LEFT 
				
					If (cursorPosition>0) cursorPosition:- 1
					
				Case KEY_RIGHT
				
					If (cursorPosition < Len(inputField)) cursorPosition:+ 1
					
				Case KEY_DELETE
				
					If (cursorPosition < Len(inputField))
						inputField= inputField[..cursorPosition]+inputField[cursorPosition+1..]
					EndIf
					
				Case KEY_END
				
					cursorPosition = Len(inputField)
					
				Case KEY_HOME
				
					cursorPosition = 0		
					
				Case KEY_UP
				
					If (commandHistory.Count() > 0)
						If (historyPos < commandHistory.Count()-1) historyPos:+ 1
						inputField= String(commandHistory.ValueAtIndex(historyPos))
						cursorPosition = Len(inputField)
					EndIf
				
				Case KEY_DOWN
				
					If (commandHistory.Count() > 0)
					If (historyPos > -1) HistoryPos:- 1
					If (historyPos < 0)
						inputField= ""
					Else
						inputField= String(commandHistory.ValueAtIndex(historyPos ))
					EndIf
					cursorPosition = Len(inputField)
					
				EndIf

					
			End Select						
		
End If
			
	End Method
	
	' Add command
	Method AddCommand(command$, help$, Action(parms$[]))
	
		Local newCommand:TConsoleCommand = New TConsoleCommand
		newCommand.desc = help
		newCommand.Action = Action
		MapInsert(commands, command.toLower(), newCommand)
	
	End Method
	
	' Execute command
	Method ExecuteCommand(command$, parms$[])
		
		Local cmd:TConsoleCommand = TConsoleCommand(MapValueForKey(commands, command.toLower()))
		If (cmd = Null)
			AddConsoleText("Unknown command: " + command)
		Else
			cmd.Action(parms)
		EndIf
	End Method
	
	' Add text to active console
	Method AddConsoleText(line:String)
		text.addLast(line)
		If text.Count()>bufferSize Then text.RemoveFirst()
		If (text.Count() > lines-1) Then currentLine = (text.Count())-(lines-1)
		If currentLine < 0 Then currentLine = 0
	End Method
	
	
	' Add to visible console
	Method AddVisibleConsoleText(line:String)
	
		If (isActive)
		
			AddConsoleText(line)
		
		End If
	
	End Method
	
	' *** Commands ***
	
	' List commands
	Method ListCommands()
	
		Local i:TMapEnumerator = commands.Values()
		For Local curCmd:TConsoleCommand=EachIn i
		
			AddConsoleText(curCmd.desc)
		
		Next
	
	End Method
	
	' Clear console
	Method ClearConsole()
	
		currentLine = 0
		text.clear()
		commandHistory.clear()
	
	End Method
	
	' Echo text
	Method Echo(parms$[])
	
		If (parms.length = 0)
		
			AddConsoleText("You need to specify some text to echo.")
			Return
						
		End If
		
		Local out$ = ""
		For Local i%=0 To parms.length-1
		
			out:+" "+parms[i]
		
		Next
		
		AddConsoleText(out[1..out.length])
	
	End Method
	
	' Dump console
	Method DumpConsole(parms$[])
	
		Local fh:TStream = WriteFile("ConsoleDump.txt")
		If (fh)
		
			WriteLine(fh, "~n[Active Console]")
			For Local pct:String=EachIn text
			
				WriteLine(fh, pct)
			
			Next

		
			CloseStream(fh)
			
			AddConsoleText("Dumped consoles to 'ConsoleDump.txt'.")
		
		Else
		
			AddConsoleText("Could not write 'ConsoleDump.txt'. Write protected media?")
		
		End If
	
	End Method
	
	' Execute script command
	Method ExecFile(args$[])
	
		If (args.length = 0)
		
			AddConsoleText("You need to specify a file to execute.")
			Return
						
		End If
		
		Local fh:TStream = OpenFile(args[0])
		If (fh = Null)
		
			AddConsoleText("File '" + args[0] + "' not found!")
			Return
		
		End If
		
		While (Not Eof(fh))
		
			Local cmdList:TList = New TList.FromArray(ReadLine(fh).Split(" "))
			Local fargs:String[] = New String[cmdList.Count() - 1]
			Local cmd:String = String(cmdList.ValueAtIndex(0))
			
			If (cmdList.Count() > 1)
			
				For Local i%=1 To cmdList.Count()-1
				
					fargs[i-1] = String(cmdList.ValueAtIndex(i)).toLower()
				
				Next
				
			End If

			ExecuteCommand(cmd, fargs)
		
		Wend

		CloseStream(fh)
	
	End Method
	
	
End Type

' Console command type
Type TConsoleCommand

	Field desc:String
	Field Action(parms$[])

End Type


'TODO: Will need to use engines keyhit stuff
' Get key utility function
Function GetKey:Int()

	Const RepeatRate : Int = 100 'ms
	Global LastTime:Long = MilliSecs()
	Global LastKey:Int = 0
	Local key:Int = 0
		
	While  Key <= 226
		If KeyDown(key) Then Exit
		Key:+ 1
	Wend
	
	
	If Key = 227 Then Return 0
	
	If Key = LastKey Then
		If MilliSecs()-LastTime < RepeatRate Then Return 0
	EndIf
	
	LastTime = MilliSecs()
	LastKey = Key
	If Key < 227 Then Return Key Else Return 0
	
End Function

Function rrAddConsoleCommand(command:String, help:String, action(params:String[]))
	TConsole.GetInstance().AddCommand( command, help, action)
End Function

Private

'A bunch of built-ins
Function cmdList(parms:String[])
	TConsole.GetInstance().ListCommands()
End Function

Function cmdClearConsole(parms:String[])
	TConsole.GetInstance().ClearConsole()
End Function

Function cmdEcho(parms:String[])
	TConsole.GetInstance().Echo(parms)
End Function

Function cmdDump(parms:String[])
	TConsole.GetInstance().DumpConsole(parms)
End Function

Function cmdExecFile(parms:String[])
	TConsole.GetInstance().ExecFile(parms)
End Function

Public

