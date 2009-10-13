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

Type TJoystickHatMapping Extends TVirtualControlMapping

	Field joystickId_:Int
	Field hatId_:Float
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_JOYSTICK
				Local data:TJoystickMessageData = TJoystickMessageData(message.data)
				If joystickId_ = data.port
					lastControlDownDigital_ = controlDownDigital_
					lastControlDownAnalogue_ = controlDownAnalogue_				
					If hatId_ = data.joystickHat
						controlDownDigital_ = 1
						controlDownAnalogue_ = 1.0
					Else
						controlDownDigital_ = 0
						controlDownAnalogue_ = 0.0
						If lastControlDownDigital_ <> controlDownDigital_
							controlHits_:+1
						EndIf
					EndIf
				EndIf
		End Select
	End Method
	
	Method SetHatId(id:Float)
		hatId_ = id
		name_ = Null
	End Method
	
	Method SetJoystickId(id:Int)
		joystickId_ = id
		name_ = null
	End Method
	
	Method GetName:String()
		If Not name_
			name_ = "Joystick(" + joystickId_ + ") "
			Select hatId_
				Case 0.0
					name_:+"Hat Up"
				Case 0.125
					name_:+"Hat Up/Right"
				Case 0.25
					name_:+"Hat Right"
				Case 0.375
					name_:+"Hat Down/Right"
				Case 0.50
					name_:+"Hat Down"
				Case 0.625
					name_:+"Hat Down/Left"
				Case 0.75
					name_:+"Hat Left"
				Case 0.875
					name_:+"Hat Up/Left"
			End Select
		End If
		Return name_
	End Method

	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"joystick", "hat", String(joystickId_), String(hatId_)], section)
	End Method
		
End Type
