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

Rem
	bbdoc: Keyboard input device.
End Rem
Type TKeyboard Extends TInputDevice

	' The Singleton instance of this class
	Global _instance:TKeyboard

	' Stores the key hits of all keys
	Field _keyHits:Int[]
		
	' Stores human readable translation of keycodes	
	Field _keyNames:String[]

	' Stores the key state of all keys
	Field _keyStates:Int[]

	' Stores the last key state of all keys
	Field _lastKeyStates:Int[]

	
	
	rem
		bbdoc: Broadcast a message on the CHANNEL_INPUT channel with data for the
		specified key
		about: Messages are sent with a message ID of MSG_KEY
	endrem
	Method BroadcastKeyStateMessage(key:Int)
		Local data:TKeyboardMessageData = New TKeyboardMessageData
		data.key = key
		data.keyState = _keyStates[key]
		data.keyHits = _keyHits[key]
		
		Local message:TMessage = New TMessage
		message.SetData(data)
		message.SetMessageId(MSG_KEY)
		message.Broadcast(CHANNEL_INPUT)
	End Method
	
	
		
	rem
		bbdoc: Returns the Singleton instance of this class
	endrem
	Function GetInstance:TKeyboard()
		If Not _instance
			Return New TKeyboard
		Else
			Return _instance
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Returns the name of the key identified by the specified ASCII keycode
	endrem
	Method GetKeyName:String(keycode:Int)
		If keycode > 0 And keycode < 256
			Return _keyNames[keycode]
		Else
			Return Null
		End If
	End Method
	
	
	
	rem
		bbdoc: Hook that listens for keyboard events
	endrem
	Function Hook:Object(id:Int, data:Object, context:Object)
	
		Local ev:TEvent=TEvent(data)
		If Not ev Return data
		
		Local keyboard:TKeyboard = TKeyboard.GetInstance()

		Select ev.id
		Case EVENT_KEYDOWN
			If Not keyboard._keyStates[ev.data]
				keyboard._keyStates[ev.data] = 1
				keyboard._keyHits[ev.data]:+1
			EndIf
		Case EVENT_KEYUP
			keyboard._keyStates[ev.data] = 0
		EndSelect

		Return data
	End Function

	
		
	rem
		bbdoc: Initialises the keyboard input device
	endrem
	Method Initialise()
		SetName("Keyboard Input")
		
		TInputManager.GetInstance().RegisterDevice(Self)
		
		InitialiseKeyNames()
		
		AddHook(EmitEventHook, Self.Hook, Null, 0)
	End Method
	
	
		
	rem
		bbdoc: Populates the keynames array with human readable name for keycodes
	endrem
	Method InitialiseKeyNames()
		_keyNames[8] = "Backspace"
		_keyNames[9] = "Tab"
		_keyNames[12] = "Clear"
		_keyNames[13] = "Return/Enter"
		_keyNames[19] = "Pause"
		_keyNames[20] = "Caps Lock"
		_keyNames[27] = "Escape"
		_keyNames[32] = "Space"
		_keyNames[33] = "Page Up"
		_keyNames[34] = "Page Down"
		_keyNames[35] = "End"
		_keyNames[36] = "Home"
		_keyNames[37] = "Cursor Left"
		_keyNames[38] = "Cursor Up"
		_keyNames[39] = "Cursor Right"
		_keyNames[40] = "Cursor Down"
		_keyNames[41] = "Select"
		_keyNames[42] = "Print Screen"
		_keyNames[43] = "Execute"
		_keyNames[44] = "Screen"
		_keyNames[45] = "Insert"
		_keyNames[46] = "Delete"
		_keyNames[47] = "Help"
		_keyNames[48] = "0"
		_keyNames[49] = "1"
		_keyNames[50] = "2"
		_keyNames[51] = "3"
		_keyNames[52] = "4"
		_keyNames[53] = "5"
		_keyNames[54] = "6"
		_keyNames[55] = "7"
		_keyNames[56] = "8"
		_keyNames[57] = "9"
		_keyNames[65] = "A"
		_keyNames[66] = "B"
		_keyNames[67] = "C"
		_keyNames[68] = "D"
		_keyNames[69] = "E"
		_keyNames[70] = "F"
		_keyNames[71] = "G"
		_keyNames[72] = "H"
		_keyNames[73] = "I"
		_keyNames[74] = "J"
		_keyNames[75] = "K"
		_keyNames[76] = "L"
		_keyNames[77] = "M"
		_keyNames[78] = "N"
		_keyNames[79] = "O"
		_keyNames[80] = "P"
		_keyNames[81] = "Q"
		_keyNames[82] = "R"
		_keyNames[83] = "S"
		_keyNames[84] = "T"
		_keyNames[85] = "U"
		_keyNames[86] = "V"
		_keyNames[87] = "W"
		_keyNames[88] = "X"
		_keyNames[89] = "Y"
		_keyNames[90] = "Z"
		_keyNames[91] = "Left Sys"
		_keyNames[92] = "Right Sys"
		_keyNames[93] = "Menu"
		_keyNames[96] = "Numpad 0"
		_keyNames[97] = "Numpad 1"
		_keyNames[98] = "Numpad 2"
		_keyNames[99] = "Numpad 3"
		_keyNames[100] = "Numpad 4"
		_keyNames[101] = "Numpad 5"
		_keyNames[102] = "Numpad 6"
		_keyNames[103] = "Numpad 7"
		_keyNames[104] = "Numpad 8"
		_keyNames[105] = "Numpad 9"
		_keyNames[106] = "Numpad *"
		_keyNames[107] = "Numpad +"
		_keyNames[109] = "Numpad -"
		_keyNames[110] = "Numpad ."
		_keyNames[111] = "Numpad /"
		_keyNames[112] = "F1"
		_keyNames[113] = "F2"
		_keyNames[114] = "F3"
		_keyNames[115] = "F4"
		_keyNames[116] = "F5"
		_keyNames[117] = "F6"
		_keyNames[118] = "F7"
		_keyNames[119] = "F8"
		_keyNames[120] = "F9"
		_keyNames[121] = "F10"
		_keyNames[122] = "F11"
		_keyNames[123] = "F12"
		_keyNames[144] = "Num Lock"
		_keyNames[145] = "Scroll Lock"
		_keyNames[160] = "Left Shift"
		_keyNames[161] = "Right Shift"
		_keyNames[162] = "Left Control"
		_keyNames[163] = "Right Control"
		_keyNames[164] = "Left Alt"
		_keyNames[165] = "Right Alt"
		_keyNames[186] = ";"
		_keyNames[187] = "="
		_keyNames[188] = ","
		_keyNames[189] = "-"
		_keyNames[190] = "."
		_keyNames[191] = "/"
		_keyNames[192] = "'"
		_keyNames[219] = "["
		_keyNames[220] = "\"
		_keyNames[221] = "]"
		_keyNames[222] = "#"
		_keyNames[223] = "`"
	End Method
	
	
		
	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		If _instance Throw "Cannot create multiple instances of Singleton Type"
		
		_instance = Self
		
		_keyHits = New Int[256]		
		_keyNames = New String[256]
		_keyStates = New Int[256]
		_lastKeyStates = New Int[256]
		
		Self.Initialise()
	End Method

	
	
	rem
		bbdoc: Update all keys and broadcasts messages on the CHANNEL_INPUT channel
	endrem
	Method Update()
		For Local key:Int = 0 To 255
			If _keyHits[key] Or _keyStates[key] Or (_lastKeyStates[key] <> _keyStates[key])
				BroadcastKeyStateMessage(key)
				_keyHits[key] = 0
			EndIf
			_lastKeyStates[key] = _keyStates[key]
		Next
	End Method



	rem
		bbdoc: Flushes the keyboard states/hits
	endrem
	Method FlushKeys()
		For Local i:Int = 0 To 255
			_lastKeyStates[i] = _keyStates[i]
			_keyStates[i] = 0
			_keyHits[i] = 0
		Next
	End Method
		
End Type


