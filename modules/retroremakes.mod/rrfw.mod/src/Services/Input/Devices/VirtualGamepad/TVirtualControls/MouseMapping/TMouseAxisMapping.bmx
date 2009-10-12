Rem
	bbdoc: A mouse axis that can be mapped to a #TVirtualControl
End Rem
Type TMouseAxisMapping Extends TVirtualControlMapping

	Field axisId_:Int
	Field axisDirection_:Int
	
	Method Update(message:TMessage)
		Select message.messageID
			Case MSG_MOUSE
				Local data:TMouseMessageData = TMouseMessageData(message.data)
				lastControlDownDigital_ = controlDownDigital_
				lastControlDownAnalogue_ = controlDownAnalogue_
				Local analogueAxisValue:Float
				Local digitalAxisValue:Int
					
				Select axisId_
					Case RR_MOUSE_X
						analogueAxisValue = data.mousePosX - data.lastMousePosX
					Case RR_MOUSE_Y
						analogueAxisValue = data.mousePosY - data.lastMousePosY
					Case RR_MOUSE_Z
						analogueAxisValue = data.mousePosZ - data.lastMousePosZ
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
					
				controlDownAnalogue_ = Abs(analogueAxisValue)
				controlDownDigital_ = digitalAxisValue
										
				If digitalAxisValue = 0
					If lastControlDownDigital_ <> controlDownDigital_
						controlHits_:+1
					EndIf
				End If
		End Select
	End Method
	
	Method SetAxis(axisId:Int, axisDirection:Int)
		axisId_ = axisId
		axisDirection_ = axisDirection
	End Method
	
	Method GetName:String()
		Local name:String
		Local direction:String
		If axisDirection_ = -1
			direction = "-"
		ElseIf axisDirection_ = 1
			direction = "+"
		End If		
		Select axisId_
			Case RR_MOUSE_X
				name = "Mouse " + direction + "X"
			Case RR_MOUSE_Y
				name = "Mouse " + direction + "Y"
			Case RR_MOUSE_Z
				name = "Mouse " + direction + "Z"
		End Select
		Return name			
	End Method
	
	
	Method Save(control:TVirtualControl)
		Local section:String = "VirtualGamepad" + control.GetGamepad().GetPaddedId()
		Local axisName:String
		Select axisId_
			Case RR_MOUSE_X
				axisName = "x"
			Case RR_MOUSE_Y
				axisName = "y"
			Case RR_MOUSE_Z
				axisName = "z"
		End Select
		rrSetStringVariables(control.GetPaddedControlId(), [control.GetName(),  ..
									"mouse", "axis", axisName,  String(axisDirection_)], section)
	End Method
	
End Type
