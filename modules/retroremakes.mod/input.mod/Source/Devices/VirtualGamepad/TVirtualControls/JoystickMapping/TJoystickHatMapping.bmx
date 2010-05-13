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

Type TJoystickHatMapping Extends TVirtualControlMapping

	Field joystickId_:Int
	Field hatId_:Float
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_JOYSTICK
				Local data:TJoystickMessageData = TJoystickMessageData(message.data)
				If joystickId_ = data.port
					SetLastDigitalStatus(GetDigitalStatus())
					SetLastAnalogueStatus(GetAnalogueStatus())
					If hatId_ = data.joystickHat
						SetDigitalStatus(1)
						SetAnalogueStatus(1.0)
					Else
						SetDigitalStatus(0)
						SetAnalogueStatus(0.0)
						If GetLastDigitalStatus() <> GetDigitalStatus()
							IncrementHits()
						EndIf
					EndIf
				EndIf
		End Select
	End Method
	
	Method SetHatId(id:Float)
		hatId_ = id
		SetName(Null)
	End Method
	
	Method SetJoystickId(id:Int)
		joystickId_ = id
		SetName(Null)
	End Method
	
	Method GetName:String()
		Local name:String = Super.GetName()
		
		If Not name
			name = "Joystick(" + joystickId_ + ") "
			Select hatId_
				Case 0.0
					name:+"Hat Up"
				Case 0.125
					name:+"Hat Up/Right"
				Case 0.25
					name:+"Hat Right"
				Case 0.375
					name:+"Hat Down/Right"
				Case 0.50
					name:+"Hat Down"
				Case 0.625
					name:+"Hat Down/Left"
				Case 0.75
					name:+"Hat Left"
				Case 0.875
					name:+"Hat Up/Left"
			End Select
			
			SetName(name)
		End If
		
		Return name
	End Method

	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"joystick", "hat", String(joystickId_), String(hatId_)], section)
	End Method
		
End Type
