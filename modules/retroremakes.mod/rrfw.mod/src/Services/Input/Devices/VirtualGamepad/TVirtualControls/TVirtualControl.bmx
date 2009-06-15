'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TVirtualControl
	Field name_:String
	Field id_:Int
	
	' A pointer to the gamepad this control belongs to
	Field gamepad_:TVirtualGamepad
	
	Field mappedControl_:TVirtualControlMapping
	Field lastControl_:TVirtualControlMapping
	Field defaultControl_:TVirtualControlMapping
	
	Field programmingMode_:Int = False
	
	
	
	Method SetControlMapping(control:TVirtualControlMapping)
		mappedControl_ = control
	End Method
	
	
	
	Method GetControlMapping:TVirtualControlMapping()
		Return mappedControl_
	End Method	
	
	
	
	Method GetDefaultControlMapping:TVirtualControlMapping()
		Return defaultControl_
	End Method	
	
	
	
	Method SetName(name:String)
		name_ = name
	End Method
	
	
	
	Method GetName:String()
		Return name_
	End Method
	
	
	
	Method EnableProgrammingMode(enable:Int = True)
		programmingMode_ = enable
		If programmingMode_
			lastControl_ = mappedControl_
			mappedControl_ = Null
		Else
			If Not mappedControl_
				mappedControl_ = defaultControl_
			End If
			mappedControl_.Save(Self)
		End If
	End Method
	
	
	
	Method GetProgrammingStatus:Int()
		Return programmingMode_
	End Method
	
	
	
	Method Update(message:TMessage)
		If mappedControl_
			mappedControl_.Update(message)
		Else
			Program(message)
		End If
	End Method
	
	
	
	Method Program(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
			Case MSG_JOYSTICK
				HandleJoystickInput(message)
			Case MSG_MOUSE
				HandleMouseInput(message)
		End Select
	End Method
	
	
	
	Method GetAnalogueStatus:Float()
		If Not mappedControl_
			Return Null
		Else
			Return mappedControl_.GetAnalogueStatus()
		End If
	End Method
	
	
	
	Method GetDigitalStatus:Int()
		If Not mappedControl_
			Return Null
		Else
			Return mappedControl_.GetDigitalStatus()
		End If
	End Method

	
	
	Method GetHits:Int()
		If Not mappedControl_
			Return Null
		Else
			Return mappedControl_.GetHits()
		End If
	End Method
	
	
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		' Use Escape key as a trigger to cancel programming mode
		If data.key = KEY_ESCAPE
			If data.keyHits
				EnableProgrammingMode(False)
				Return
			EndIf
		End If
		If data.keyHits	'Not interested unless key has been released
			mappedControl_ = New TKeyboardMapping
			TKeyboardMapping(mappedControl_).SetButton(data.key)
			EnableProgrammingMode(False)
		EndIf
	End Method
	
	
	
	Method HandleJoystickInput(message:TMessage)
		Local data:TJoystickMessageData = TJoystickMessageData(message.data)
		'Check buttons first
		For Local i:Int = 0 To data.nButtons - 1
			If data.buttonHit[i]
				mappedControl_ = New TJoystickButtonMapping
				TJoystickButtonMapping(mappedControl_).SetButtonId(i)
				TJoystickButtonMapping(mappedControl_).SetJoystickId(data.port)
				EnableProgrammingMode(False)
			End If
		Next
		'Check hats
		If data.joystickHat <> - 1.000
			mappedControl_ = New TJoystickHatMapping
			TJoystickHatMapping(mappedControl_).SetHatId(data.joystickHat)
			TJoystickHatMapping(mappedControl_).SetJoystickId(data.port)
			EnableProgrammingMode(False)
		End If
		'Check axis
		Local axis:Int
		Local direction:Int
		FindJoystickAxis(data, axis, direction)
		If axis <> 0
			mappedControl_ = New TJoystickAxisMapping
			TJoystickAxisMapping(mappedControl_).SetAxis(axis, direction)
			TJoystickAxisMapping(mappedControl_).SetJoystickId(data.port)
			EnableProgrammingMode(False)
		End If
	End Method
	
	
	
	Method HandleMouseInput(message:TMessage)
		Local data:TMouseMessageData = TMouseMessageData(message.data)
		'Check buttons first
		For Local i:Int = 1 To 3
			If data.mouseStates[i]
				mappedControl_ = New TMouseButtonMapping
				TMouseButtonMapping(mappedControl_).SetButtonId(i)
				EnableProgrammingMode(False)
				Exit
			End If
		Next
		'Now check axis
		Local axis:Int
		Local direction:Int
		FindMouseAxis(data, axis, direction)
		If axis <> 0
			mappedControl_ = New TMouseAxisMapping
			TMouseAxisMapping(mappedControl_).SetAxis(axis, direction)
			EnableProgrammingMode(False)
		End If		
	End Method

	
	
	Method SetDefaultJoystickAxisControl(port:Int, axis:String, direction:Int)
		Local axisId:Int = GetJoystickAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			defaultControl_ = New TJoystickAxisMapping
			TJoystickAxisMapping(defaultControl_).SetAxis(axisId, direction)
			TJoystickAxisMapping(defaultControl_).SetJoystickId(port)
			If Not mappedControl_
				mappedControl_ = defaultControl_
			End If
		EndIf
	End Method
	
	
	
	Method SetJoystickAxisControl(port:Int, axis:String, direction:Int)
		Local axisId:Int = GetJoystickAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			mappedControl_ = New TJoystickAxisMapping
			TJoystickAxisMapping(mappedControl_).SetAxis(axisId, direction)
			TJoystickAxisMapping(mappedControl_).SetJoystickId(port)
		EndIf
	End Method

	
	
	Method SetDefaultMouseAxisControl(axis:String, direction:Int)
		Local axisId:Int = GetMouseAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			defaultControl_ = New TMouseAxisMapping
			TMouseAxisMapping(defaultControl_).SetAxis(axisId, direction)
			If Not mappedControl_
				mappedControl_ = defaultControl_
			End If			
		End If
	End Method	
	
	
	
	Method SetMouseAxisControl(axis:String, direction:Int)
		Local axisId:Int = GetMouseAxisId(axis)
		If axisId And (direction = -1 Or direction = 1)
			mappedControl_ = New TMouseAxisMapping
			TMouseAxisMapping(mappedControl_).SetAxis(axisId, direction)
		End If
	End Method
	
	
	
	Method GetMouseAxisId:Int(axis:String)
		Select axis.ToLower()
			Case "x"
				Return RR_MOUSE_X
			Case "y"
				Return RR_MOUSE_Y
			Case "z"
				Return RR_MOUSE_Z
			Default
				Return Null
		End Select
	End Method
	
	
	
	Method GetJoystickAxisId:Int(axis:String)
		Select axis.ToLower()
			Case "x"
				Return RR_JOY_X
			Case "y"
				Return RR_JOY_Y
			Case "z"
				Return RR_JOY_Z
			Case "r"
				Return RR_JOY_R
			Case "u"
				Return RR_JOY_U
			Case "v"
				Return RR_JOY_V
			Case "yaw"
				Return RR_JOY_YAW
			Case "pitch"
				Return RR_JOY_PITCH
			Case "roll"
				Return RR_JOY_ROLL
			Case "wheel"
				Return RR_JOY_WHEEL
			Default
				Return Null
		End Select
	End Method
		
	
			
	Method SetDefaultKeyboardControl(keyId:Int)
		If keyId >= 0 And keyId < 256
			defaultControl_ = New TKeyboardMapping
			TKeyboardMapping(defaultControl_).SetButton(keyId)
			If Not mappedControl_
				mappedControl_ = defaultControl_
			End If
		End If
	End Method
	
	
	
	Method SetKeyboardControl(keyId:Int)
		If keyId >= 0 And keyId < 256
			mappedControl_ = New TKeyboardMapping
			TKeyboardMapping(mappedControl_).SetButton(keyId)
		End If
	End Method
	
	
	
	Method SetDefaultJoystickButtonControl(port:Int, buttonId:Int)
		If buttonId < TJoystickManager.GetInstance().GetJoystick(port).CountButtons()
			defaultControl_ = New TJoystickButtonMapping
			TJoystickButtonMapping(defaultControl_).SetButtonId(buttonId)
			TJoystickButtonMapping(defaultControl_).SetJoystickId(port)
			If Not mappedControl_
				mappedControl_ = defaultControl_
			End If
		End If
	End Method
	
	
	
	Method SetJoystickButtonControl(port:Int, buttonId:Int)
		If buttonId < TJoystickManager.GetInstance().GetJoystick(port).CountButtons()
			mappedControl_ = New TJoystickButtonMapping
			TJoystickButtonMapping(mappedControl_).SetButtonId(buttonId)
			TJoystickButtonMapping(mappedControl_).SetJoystickId(port)
		End If
	End Method
	
	
	
	Method SetMouseButtonControl(button:String)
		Local buttonId:Int = GetMouseButtonId(button)
		If buttonId
			mappedControl_ = New TMouseButtonMapping
			TMouseButtonMapping(mappedControl_).SetButtonId(buttonId)
		End If
	End Method
	
	
	
	Method SetDefaultMouseButtonControl(button:String)
		Local buttonId:Int = GetMouseButtonId(button)
		If buttonId
			defaultControl_ = New TMouseButtonMapping
			TMouseButtonMapping(defaultControl_).SetButtonId(buttonId)
			If Not mappedControl_
				mappedControl_ = defaultControl_
			End If			
		End If
	End Method		
	
	
	
	Method GetMouseButtonId:Int(button:String)
		Select button.ToLower()
			Case "left"
				Return RR_MOUSE_LEFT
			Case "right"
				Return RR_MOUSE_RIGHT
			Case "middle"
				Return RR_MOUSE_MIDDLE
			Default
				Return Null
		End Select
	End Method

	
		
	Method SetDefaultJoystickHatControl(port:Int, hatId:Float)
		defaultControl_ = New TJoystickHatMapping
		TJoystickHatMapping(defaultControl_).SetHatId(hatId)
		TJoystickHatMapping(defaultControl_).SetJoystickId(port)
		If Not mappedControl_
			mappedControl_ = defaultControl_
		End If
	End Method
	
	
	
	Method SetJoystickHatControl(port:Int, hatId:Float)
		mappedControl_ = New TJoystickHatMapping
		TJoystickHatMapping(mappedControl_).SetHatId(hatId)
		TJoystickHatMapping(mappedControl_).SetJoystickId(port)
	End Method		
	
	
	
	Method FindJoystickAxis(data:TJoystickMessageData, axis:Int Var, direction:Int Var)
		axis = 0
		direction = 0

		Local value:Float = 0.0

		If Abs(data.joystickX) > Abs(value)
			axis = RR_JOY_X
			value = data.joystickX
		EndIf
		If Abs(data.joystickY) > Abs(value)
			axis = RR_JOY_Y
			value = data.joystickY
		EndIf
		If Abs(data.joystickZ) > Abs(value)
			axis = RR_JOY_Z
			value = data.joystickZ
		EndIf				
		If Abs(data.joystickR) > Abs(value)
			axis = RR_JOY_R
			value = data.joystickR
		EndIf
		If Abs(data.joystickU) > Abs(value)
			axis = RR_JOY_U
			value = data.joystickU
		EndIf
		If Abs(data.joystickV) > Abs(value)
			axis = RR_JOY_V
			value = data.joystickV
		EndIf
		If Abs(data.joystickYaw) > Abs(value)
			axis = RR_JOY_YAW
			value = data.joystickYaw
		EndIf
		If Abs(data.joystickPitch) > Abs(value)
			axis = RR_JOY_PITCH
			value = data.joystickPitch
		EndIf				
		If Abs(data.joystickRoll) > Abs(value)
			axis = RR_JOY_ROLL
			value = data.joystickRoll
		EndIf
		If Abs(data.joystickWheel) > Abs(value)
			axis = RR_JOY_WHEEL
			value = data.joystickWheel
		EndIf						
		
		If axis <> 0
			If value < 0.0 Then direction = -1
			If value > 0.0 Then direction = 1
		End If
	End Method
	
	
	
	Method FindMouseAxis(data:TMouseMessageData, axis:Int Var, direction:Int Var)
		axis = 0
		direction = 0

		Local value:Float = 0.0

		If Abs(data.mousePosX - data.lastMousePosX) > Abs(value)
			axis = RR_MOUSE_X
			value = data.mousePosX - data.lastMousePosX
		EndIf
		If Abs(data.mousePosY - data.lastMousePosY) > Abs(value)
			axis = RR_MOUSE_Y
			value = data.mousePosY - data.lastMousePosY
		EndIf
		If Abs(data.mousePosZ - data.lastMousePosZ) > Abs(value)
			axis = RR_MOUSE_Z
			value = data.mousePosZ - data.lastMousePosZ
		EndIf				
		
		If axis <> 0
			If value < 0.0 Then direction = -1
			If value > 0.0 Then direction = 1
		End If
	End Method

	
	
	Method GetPaddedControlId:String()
		Local digits:String = String(id_)
		While digits.Length < 3
			digits = "0" + digits
		Wend
		Return "CONTROL" + digits
	End Method
	
End Type
