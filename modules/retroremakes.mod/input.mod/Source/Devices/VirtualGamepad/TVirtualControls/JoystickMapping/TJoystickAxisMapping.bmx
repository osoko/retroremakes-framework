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
	bbdoc: A joystick axis that can be mapped to a #TVirtualControl
End Rem
Type TJoystickAxisMapping Extends TVirtualControlMapping
	
	Field axisId_:Int

	Field axisDirection_:Int	' -1 or 1 for absolute directional values. 2 for values -1.0 to 1.0

	Field joystickId_:Int
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_JOYSTICK
				Local data:TJoystickMessageData = TJoystickMessageData(message.data)
				
				If joystickId_ = data.port
				
					SetLastDigitalStatus(GetDigitalStatus())
					
					SetLastAnalogueStatus(GetAnalogueStatus())
					
					Local analogueAxisValue:Float
					Local digitalAxisValue:Int
					
					Select axisId_
						Case RR_JOY_X
							analogueAxisValue = data.joystickX
						Case RR_JOY_Y
							analogueAxisValue = data.joystickY
						Case RR_JOY_Z
							analogueAxisValue = data.joystickZ
						Case RR_JOY_R
							analogueAxisValue = data.joystickR
						Case RR_JOY_U
							analogueAxisValue = data.joystickU
						Case RR_JOY_V
							analogueAxisValue = data.joystickV
						Case RR_JOY_YAW
							analogueAxisValue = data.joystickYaw
						Case RR_JOY_PITCH
							analogueAxisValue = data.joystickPitch
						Case RR_JOY_ROLL
							analogueAxisValue = data.joystickRoll
						Case RR_JOY_WHEEL
							analogueAxisValue = data.joystickWheel
					End Select
					
					If axisDirection_ = 1
						If analogueAxisValue <= 0.0
							analogueAxisValue = 0.0
							digitalAxisValue = 0
						Else
							digitalAxisValue = 1
						End If
					ElseIf axisDirection_ = -1
						If analogueAxisValue >= 0.0
							analogueAxisValue = 0.0
							digitalAxisValue = 0
						Else
							digitalAxisValue = 1
						End If
					End If

					If axisDirection_ = 1 Or axisDirection_ = -1
						SetAnalogueStatus(Abs(analogueAxisValue))
					Else
						SetAnalogueStatus(analogueAxisValue)
					EndIf
					
					SetDigitalStatus(digitalAxisValue)
										
					If digitalAxisValue = 0
						If GetLastDigitalStatus() <> GetDigitalStatus()
							IncrementHits()
						EndIf
					End If

				EndIf
		End Select
	End Method

	Method SetJoystickId(id:Int)
		joystickId_ = id
		SetName(Null)
	End Method
			
	Method SetAxis(axisId:Int, axisDirection:Int)
		axisId_ = axisId
		axisDirection_ = axisDirection
		SetName(Null)
	End Method
	
	Method GetAxisDirection:Int()
		Return axisDirection_
	End Method
		
	Method GetName:String()
		Local name:String = Super.GetName()

		If Not name
			name = "Joystick(" + joystickId_ + ") "
			
			Local direction:String
			
			If axisDirection_ = -1
				direction = "-"
			ElseIf axisDirection_ = 1
				direction = "+"
			ElseIf axisDirection_ = 2
				direction = ""
			End If
				
			Select axisId_
				Case RR_JOY_X
					name:+direction + "X"
				Case RR_JOY_Y
					name:+direction + "Y"
				Case RR_JOY_Z
					name:+direction + "Z"
				Case RR_JOY_R
					name:+direction + "R"
				Case RR_JOY_U
					name:+direction + "U"
				Case RR_JOY_V
					name:+direction + "V"
				Case RR_JOY_YAW
					name:+direction + "Yaw"
				Case RR_JOY_PITCH
					name:+direction + "Pitch"
				Case RR_JOY_ROLL
					name:+direction + "Roll"
				Case RR_JOY_WHEEL
					name:+direction + "Wheel"
			End Select
			name:+" Axis"
			SetName(name)
		EndIf
		
		Return name
	End Method

	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		Local axisName:String
		Select axisId_
			Case RR_JOY_X
				axisName = "x"
			Case RR_JOY_Y
				axisName = "y"
			Case RR_JOY_Z
				axisName = "z"
			Case RR_JOY_R
				axisName = "r"
			Case RR_JOY_U
				axisName = "u"
			Case RR_JOY_V
				axisName = "v"
			Case RR_JOY_YAW
				axisName = "yaw"
			Case RR_JOY_PITCH
				axisName = "pitch"
			Case RR_JOY_ROLL
				axisName = "roll"
			Case RR_JOY_WHEEL
				axisName = "wheel"
		End Select
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"joystick", "axis", String(joystickId_), axisName,  ..
									String(axisDirection_)], section)
	End Method
	
End Type
