rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: A joystick button that can be mapped to a #TVirtualControl
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
						SetDigitalStatus(data.buttonDown[buttonId_])
						SetAnalogueStatus(Float(GetDigitalStatus()))
						SetHits(data.buttonHit[buttonId_])
					EndIf
				EndIf
		End Select
	End Method
	
	Method SetButtonId(id:Int)
		buttonId_ = id
		SetName(Null)
	End Method
	
	Method SetJoystickId(id:Int)
		joystickId_ = id
		SetName(Null)
	End Method
	
	Method GetName:String()
		If Not Super.GetName()
			SetName("Joystick(" + joystickId_ + ") Button " + buttonId_)
		End If
		Return Super.GetName()
	End Method
	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"joystick", "button", String(joystickId_), String(buttonId_)], section)
	End Method	
End Type
