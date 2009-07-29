'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TJoystickButtonMapping Extends TVirtualControlMapping

	Field joystickId_:Int
	Field buttonId_:Int
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_JOYSTICK
				Local data:TJoystickMessageData = TJoystickMessageData(message.data)
				If joystickId_ = data.port
					If buttonId_ >= 0 And buttonId_ < data.nButtons
						controlDownDigital_ = data.buttonDown[buttonId_]
						controlDownAnalogue_ = Float(controlDownDigital_)
						controlHits_ = data.buttonHit[buttonId_]
					EndIf
				EndIf
		End Select
	End Method
	
	Method SetButtonId(id:Int)
		buttonId_ = id
		name_ = Null
	End Method
	
	Method SetJoystickId(id:Int)
		joystickId_ = id
		name_ = Null
	End Method
	
	Method GetName:String()
		If Not name_
			name_ = "Joystick(" + joystickId_ + ") Button " + buttonId_
		End If
		Return name_
	End Method
	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"joystick", "button", String(joystickId_), String(buttonId_)], section)
	End Method	
End Type
