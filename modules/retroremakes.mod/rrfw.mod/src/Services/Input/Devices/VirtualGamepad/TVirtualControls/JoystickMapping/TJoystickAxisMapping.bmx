'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TJoystickAxisMapping Extends TVirtualControlMapping
	
	Field axisId_:Int

	Field axisDirection_:Int	' -1 or 1

	Field joystickId_:Int
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_JOYSTICK
				Local data:TJoystickMessageData = TJoystickMessageData(message.data)
				If joystickId_ = data.port
					lastControlDownDigital_ = controlDownDigital_
					lastControlDownAnalogue_ = controlDownAnalogue_			
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
					
					controlDownAnalogue_ = analogueAxisValue
					controlDownDigital_ = digitalAxisValue
										
					If digitalAxisValue = 0
						If lastControlDownDigital_ <> controlDownDigital_
							controlHits_:+1
						EndIf
					End If

				EndIf
		End Select
	End Method

	Method SetJoystickId(id:Int)
		joystickId_ = id
		name_ = Null
	End Method
			
	Method SetAxis(axisId:Int, axisDirection:Int)
		axisId_ = axisId
		axisDirection_ = axisDirection
		name_ = Null
	End Method
	
	Method GetName:String()
		If Not name_
			name_ = "Joystick(" + joystickId_ + ") "
			Local direction:String
			If axisDirection_ = -1
				direction = "-"
			ElseIf axisDirection_ = 1
				direction = "+"
			End If		
			Select axisId_
				Case RR_JOY_X
					name_:+direction + "X"
				Case RR_JOY_Y
					name_:+direction + "Y"
				Case RR_JOY_Z
					name_:+direction + "Z"
				Case RR_JOY_R
					name_:+direction + "R"
				Case RR_JOY_U
					name_:+direction + "U"
				Case RR_JOY_V
					name_:+direction + "V"
				Case RR_JOY_YAW
					name_:+direction + "Yaw"
				Case RR_JOY_PITCH
					name_:+direction + "Pitch"
				Case RR_JOY_ROLL
					name_:+direction + "Roll"
				Case RR_JOY_WHEEL
					name_:+direction + "Wheel"
			End Select
			name_:+" Axis"
		EndIf
		Return name_
	End Method

	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.gamepad_.GetPaddedId()
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
