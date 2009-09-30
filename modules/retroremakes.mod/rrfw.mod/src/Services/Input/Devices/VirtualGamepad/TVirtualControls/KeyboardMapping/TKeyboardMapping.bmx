Rem
	bbdoc: A keyboard key that can be mapped to a #TVirtualControl
End Rem
Type TKeyboardMapping Extends TVirtualControlMapping

	Field keyboardButtonId_:Int

	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
				If data.key = keyboardButtonId_
					controlDownDigital_ = data.keyState
					controlDownAnalogue_ = Float(controlDownDigital_)
					controlHits_ = data.keyHits
				EndIf
		End Select		
	End Method
	
	Method SetButton(id:Int)
		If id >= 0 And id < 256
			keyboardButtonId_ = id
			name_ = Null
		EndIf
	End Method
	
	Method GetButton(id:Int)
		keyboardButtonId_ = id
	End Method
	
	Method GetName:String()
		If Not name_
			name_ = TKeyboard.GetKeyName(keyboardButtonId_)
		EndIf
		Return name_
	End Method

	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"keyboard", String(keyboardButtonId_)], section)
	End Method
			
End Type
