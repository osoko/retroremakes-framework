' Some better joystick axis consts than those provided in pub.freejoy
Const RR_JOY_X:Int = 1
Const RR_JOY_Y:Int = 2
Const RR_JOY_Z:Int = 4
Const RR_JOY_R:Int = 8
Const RR_JOY_U:Int = 16
Const RR_JOY_V:Int = 32
Const RR_JOY_YAW:Int = 64
Const RR_JOY_PITCH:Int = 128
Const RR_JOY_ROLL:Int = 256
Const RR_JOY_HAT:Int = 512
Const RR_JOY_WHEEL:Int = 1024

Rem
	bbdoc: Joystick input device.
End Rem
Type TJoystick

	Global pollProfiler:TProfilerSample
	Const DEFAULT_ANALOGUE_DEADZONE:Float = 0.3
	
	Field name_:String
	Field port_:Int

	Field nButtons_:Int
	Field availableAxis_:Int
	
	Field deadzone_:Float = DEFAULT_ANALOGUE_DEADZONE
	
	Method New()
		pollProfiler = rrCreateProfilerSample("Joystick: Poll")
	End Method

	Method Profile(port:Int)
		port_ = port
		name_ = JoyName(port_) + " [" + port_ + "]"
		nButtons_ = CountButtons()
		availableAxis_ = JoyAxisCaps(port_)
	End Method
	
	Method GetName:String()
		Return name_
	End Method
	
	Method GetPortNumber:Int()
		Return port_
	End Method
	
	Method CountButtons:Int()
		Local buttons:Int = JoyButtonCaps(port_)
		
		nButtons_ = 0
		Local mask:Int = 1
		For Local i:Int = 1 To 32
			If buttons & mask
				nButtons_:+1
			End If
			mask = mask Shl 1
		Next
		
		Return nButtons_
	End Method

	Method SetDeadzone(deadzone:Float)
		If deadzone < 0.0 Then deadzone = 0.0
		If deadzone > 1.0 Then deadzone = 1.0
		deadzone_ = deadzone
	End Method
	
	Method GetDeadzone:Float()
		Return deadzone_
	End Method	
	
	Method Poll:TJoystickMessageData()
		Local joystickData:TJoystickMessageData = New TJoystickMessageData
		
		joystickData.buttonDown = New Int[nButtons_]
		joystickData.buttonHit = New Int[nButtons_]

		rrStartProfilerSample(pollProfiler)
		joystickData.port = port_
		joystickData.nButtons = nButtons_
		joystickData.availableAxis = availableAxis_
		
		'Poll all available buttons
		For Local i:Int = 0 To nButtons_ - 1
			joystickData.buttonDown[i] = JoyDown(i, port_)
			joystickData.buttonHit[i] = JoyHit(i, port_)
		Next
		
		'Poll all available axis
		If availableAxis_ & RR_JOY_X Then joystickData.joystickX = CheckDeadzone(JoyX(port_))
		If availableAxis_ & RR_JOY_Y Then joystickData.joystickY = CheckDeadzone(JoyY(port_))
		If availableAxis_ & RR_JOY_Z Then joystickData.joystickZ = CheckDeadzone(JoyZ(port_))
		If availableAxis_ & RR_JOY_R Then joystickData.joystickR = CheckDeadzone(JoyR(port_))
		If availableAxis_ & RR_JOY_U Then joystickData.joystickU = CheckDeadzone(JoyU(port_))
		If availableAxis_ & RR_JOY_V Then joystickData.joystickV = CheckDeadzone(JoyV(port_))
		If availableAxis_ & RR_JOY_YAW Then joystickData.joystickYaw = CheckDeadzone(JoyYaw(port_))
		If availableAxis_ & RR_JOY_PITCH Then joystickData.joystickPitch = CheckDeadzone(JoyPitch(port_))
		If availableAxis_ & RR_JOY_ROLL Then joystickData.joystickRoll = CheckDeadzone(JoyRoll(port_))
		If availableAxis_ & RR_JOY_HAT Then joystickData.joystickHat = JoyHat(port_)
		If availableAxis_ & RR_JOY_WHEEL Then joystickData.joystickWheel = CheckDeadzone(JoyWheel(port_))
		rrStopProfilerSample(pollProfiler)
		Return joystickData
	End Method
	
	Method CheckDeadzone:Float(axis:Float)
		If Abs(axis) < deadzone_
			Return 0.0
		Else
			Return axis
		EndIf
	End Method
End Type
