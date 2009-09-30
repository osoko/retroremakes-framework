'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TKeyboard Extends TInputDevice

	Global instance:TKeyboard

	' Stores human readable translation of keycodes	
	Global keyNames_:String[256]
	
	Field lastKeyStates:Int[256]
	Field keyStates:Int[256]
	Field keyHits:Int[256]

	Method New()
		If instance Throw "Cannot create multiple instances of Singleton Type"
		instance = Self
		Self.Initialise()
	End Method
	
	Function GetInstance:TKeyboard()
		If Not instance
			Return New TKeyboard
		Else
			Return instance
		EndIf
	EndFunction

	Function GetKeyName:String(keycode:Int)
		If keycode > 0 And keycode < 256
			Return keyNames_[keycode]
		Else
			Return Null
		End If
	End Function
	
	Method Initialise()
		name = "Keyboard Input"
		TInputManager.GetInstance().RegisterDevice(Self)
		InitialiseKeyNames()
		AddHook(EmitEventHook, Self.Hook, Null, 0)
	End Method
	
	Function Hook:Object(id:Int, data:Object, context:Object)
	
		Local ev:TEvent=TEvent(data)
		If Not ev Return data
		
		Local keyboard:TKeyboard = TKeyboard.GetInstance()

		Select ev.id
		Case EVENT_KEYDOWN
			If Not keyboard.keyStates[ev.data]
				keyboard.keyStates[ev.data] = 1
				keyboard.keyHits[ev.data]:+1
			EndIf
		Case EVENT_KEYUP
			keyboard.keyStates[ev.data] = 0
		EndSelect

		Return data
	End Function
	
	Method Update()
		For Local key:Int = 0 To 255
			If keyHits[key] Or keyStates[key] Or (lastKeyStates[key] <> keyStates[key])
				SendKeyStateMessage(key)
				keyHits[key] = 0
			EndIf
			lastKeyStates[key] = keyStates[key]
		Next
	End Method

	Method SendKeyStateMessage(key:Int)
		Local message:TMessage = New TMessage
		Local data:TKeyboardMessageData = New TKeyboardMessageData
		data.key = key
		data.keyState = keyStates[key]
		data.keyHits = keyHits[key]
		message.SetData(data)
		message.SetMessageID(MSG_KEY)
		message.Broadcast(CHANNEL_INPUT)
	End Method
	
	Method FlushKeys()
		For Local i:Int = 0 To 255
			lastKeyStates[i] = keyStates[i]
			keyStates[i] = 0
			keyHits[i] = 0
		Next
	End Method

	Method InitialiseKeyNames()
		keyNames_[8] = "Backspace"
		keyNames_[9] = "Tab"
		keyNames_[12] = "Clear"
		keyNames_[13] = "Return/Enter"
		keyNames_[19] = "Pause"
		keyNames_[20] = "Caps Lock"
		keyNames_[27] = "Escape"
		keyNames_[32] = "Space"
		keyNames_[33] = "Page Up"
		keyNames_[34] = "Page Down"
		keyNames_[35] = "End"
		keyNames_[36] = "Home"
		keyNames_[37] = "Cursor Left"
		keyNames_[38] = "Cursor Up"
		keyNames_[39] = "Cursor Right"
		keyNames_[40] = "Cursor Down"
		keyNames_[41] = "Select"
		keyNames_[42] = "Print Screen"
		keyNames_[43] = "Execute"
		keyNames_[44] = "Screen"
		keyNames_[45] = "Insert"
		keyNames_[46] = "Delete"
		keyNames_[47] = "Help"
		keyNames_[48] = "0"
		keyNames_[49] = "1"
		keyNames_[50] = "2"
		keyNames_[51] = "3"
		keyNames_[52] = "4"
		keyNames_[53] = "5"
		keyNames_[54] = "6"
		keyNames_[55] = "7"
		keyNames_[56] = "8"
		keyNames_[57] = "9"
		keyNames_[65] = "A"
		keyNames_[66] = "B"
		keyNames_[67] = "C"
		keyNames_[68] = "D"
		keyNames_[69] = "E"
		keyNames_[70] = "F"
		keyNames_[71] = "G"
		keyNames_[72] = "H"
		keyNames_[73] = "I"
		keyNames_[74] = "J"
		keyNames_[75] = "K"
		keyNames_[76] = "L"
		keyNames_[77] = "M"
		keyNames_[78] = "N"
		keyNames_[79] = "O"
		keyNames_[80] = "P"
		keyNames_[81] = "Q"
		keyNames_[82] = "R"
		keyNames_[83] = "S"
		keyNames_[84] = "T"
		keyNames_[85] = "U"
		keyNames_[86] = "V"
		keyNames_[87] = "W"
		keyNames_[88] = "X"
		keyNames_[89] = "Y"
		keyNames_[90] = "Z"
		keyNames_[91] = "Left Sys"
		keyNames_[92] = "Right Sys"
		keyNames_[93] = "Menu"
		keyNames_[96] = "Numpad 0"
		keyNames_[97] = "Numpad 1"
		keyNames_[98] = "Numpad 2"
		keyNames_[99] = "Numpad 3"
		keyNames_[100] = "Numpad 4"
		keyNames_[101] = "Numpad 5"
		keyNames_[102] = "Numpad 6"
		keyNames_[103] = "Numpad 7"
		keyNames_[104] = "Numpad 8"
		keyNames_[105] = "Numpad 9"
		keyNames_[106] = "Numpad *"
		keyNames_[107] = "Numpad +"
		keyNames_[109] = "Numpad -"
		keyNames_[110] = "Numpad ."
		keyNames_[111] = "Numpad /"
		keyNames_[112] = "F1"
		keyNames_[113] = "F2"
		keyNames_[114] = "F3"
		keyNames_[115] = "F4"
		keyNames_[116] = "F5"
		keyNames_[117] = "F6"
		keyNames_[118] = "F7"
		keyNames_[119] = "F8"
		keyNames_[120] = "F9"
		keyNames_[121] = "F10"
		keyNames_[122] = "F11"
		keyNames_[123] = "F12"
		keyNames_[144] = "Num Lock"
		keyNames_[145] = "Scroll Lock"
		keyNames_[160] = "Left Shift"
		keyNames_[161] = "Right Shift"
		keyNames_[162] = "Left Control"
		keyNames_[163] = "Right Control"
		keyNames_[164] = "Left Alt"
		keyNames_[165] = "Right Alt"
		keyNames_[186] = ";"
		keyNames_[187] = "="
		keyNames_[188] = ","
		keyNames_[189] = "-"
		keyNames_[190] = "."
		keyNames_[191] = "/"
		keyNames_[192] = "'"
		keyNames_[219] = "["
		keyNames_[220] = "\"
		keyNames_[221] = "]"
		keyNames_[222] = "#"
		keyNames_[223] = "`"
	End Method
		
End Type


Function rrEnableKeyboardInput(enable:Int = True)
	TInputManager.GetInstance().keyboardEnabled = True
End Function

