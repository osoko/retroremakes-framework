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

	' A reasonable default deadzone value for analogue axis
	Const DEFAULT_ANALOGUE_DEADZONE:Float = 0.3

	' A bitmask showing which axis are available on this joystick
	Field _availableAxis:Int

	' Deadzone for analogue axis on this joystick
	Field _deadzone:Float
			
	' Human readable name for the joystick
	Field _name:String

	' The number of buttons available on this joystick
	Field _nButtons:Int
	
	' The port this joystick is on according to pub.freejoy
	Field _port:Int

	
	
	rem
		bbdoc: Applies the configured deadzone to a supplied axis value
		about: Clamps the supplied value to 0.0 if it is less than the configured
		deadzone value
	endrem
	Method ApplyDeadzone:Float(axis:Float)
		If Abs(axis) < GetDeadzone()
			Return 0.0
		Else
			Return axis
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Counts the number of buttons available on this joystick
	endrem
	Method CountButtons:Int()
		Local buttons:Int = JoyButtonCaps(GetPort())
		
		Local nButtons:Int = 0
		Local mask:Int = 1
		For Local i:Int = 1 To 32
			If buttons & mask
				nButtons:+1
			End If
			mask = mask Shl 1
		Next
		
		Return nButtons
	End Method
	
	
		
	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		SetDeadzone(DEFAULT_ANALOGUE_DEADZONE)
	End Method

	
	
	rem
		bbdoc: Profile the joystick to find its capabilities
	endrem
	Method Profile(port:Int)
		SetPort(port)
		SetName(JoyName(port) + " [" + port + "]")
		SetButtonCount(CountButtons())
		SetAvailableAxis(JoyAxisCaps(port))
	End Method
	
	
	
	rem
		bbdoc: Get the axis available on this joystick
		about: The return value is a bitmask
	endrem
	Method GetAvailableAxis:Int()
		Return _availableAxis
	End Method
		
	
	
	rem
		bbdoc: Get the number of buttons available on this joystick
	endrem
	Method GetButtonCount:Int()
		Return _nButtons
	End Method
		
	
	
	rem
		bbdoc: Get the deadzone value for this joystick
	endrem
	Method GetDeadzone:Float()
		Return _deadzone
	End Method
	
	
	
	rem
		bbdoc: Get the human readable name of this joystick
	endrem	
	Method GetName:String()
		Return _name
	End Method
	
	
	
	rem
		bbdoc: Get the port that this joystick is connected to
	endrem
	Method GetPort:Int()
		Return _port
	End Method
	
	
	
	rem
		bbdoc: Polls the joystick and returns message data containing its current
		state
		about: This is called by the joystick manager during the update loop and
		the resultant message data is broadcast on the CHANNEL_INPUT channel with
		a message ID of MSG_JOYSTICK so any interested parties can listen for it
	endrem
	Method Poll:TJoystickMessageData()
		Local joystickData:TJoystickMessageData = New TJoystickMessageData
		
		joystickData.port = GetPort()
		joystickData.nButtons = GetButtonCount()
		joystickData.availableAxis = GetAvailableAxis()
				
		joystickData.buttonDown = New Int[joystickData.nButtons]
		joystickData.buttonHit = New Int[joystickData.nButtons]
		
		'Poll all available buttons
		For Local i:Int = 0 To joystickData.nButtons - 1
			joystickData.buttonDown[i] = JoyDown(i, joystickData.port)
			joystickData.buttonHit[i] = JoyHit(i, joystickData.port)
		Next
		
		'Poll all available axis
		If joystickData.availableAxis & RR_JOY_X
			joystickData.joystickX = ApplyDeadzone(JoyX(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_Y
			joystickData.joystickY = ApplyDeadzone(JoyY(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_Z
			joystickData.joystickZ = ApplyDeadzone(JoyZ(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_R
			joystickData.joystickR = ApplyDeadzone(JoyR(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_U
			joystickData.joystickU = ApplyDeadzone(JoyU(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_V
			joystickData.joystickV = ApplyDeadzone(JoyV(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_YAW
			joystickData.joystickYaw = ApplyDeadzone(JoyYaw(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_PITCH
			joystickData.joystickPitch = ApplyDeadzone(JoyPitch(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_ROLL
			joystickData.joystickRoll = ApplyDeadzone(JoyRoll(joystickData.port))
		EndIf
		
		If joystickData.availableAxis & RR_JOY_HAT
			joystickData.joystickHat = JoyHat(joystickData.port)
		EndIf
		
		If joystickData.availableAxis & RR_JOY_WHEEL
			joystickData.joystickWheel = ApplyDeadzone(JoyWheel(joystickData.port))
		EndIf

		Return joystickData
	End Method
	


	rem
		bbdoc: Sets the axis available on this joystick
	endrem
	Method SetAvailableAxis(availableAxis:Int)
		_availableAxis = availableAxis
	End Method
	
	
	
	rem
		bbdoc: Sets the number of buttons available on this joystick
	endrem
	Method SetButtonCount(nButtons:Int)
		_nButtons = nButtons
	End Method
	
	
	
	rem
		bbdoc: Sets the deadzone to use for analogue axis on this joystick
	endrem	
	Method SetDeadzone(deadzone:Float)
		If deadzone < 0.0 Then deadzone = 0.0
		If deadzone > 1.0 Then deadzone = 1.0
		_deadzone = deadzone
	End Method
	

	
	rem
		bbdoc: Sets the name of this joystick
	endrem
	Method SetName(name:String)
		_name = name
	End Method
	
	
	
	rem
		bbdoc: Set the port this joystick as attached to
	endrem
	Method SetPort(port:Int)
		_port = port
	End Method

End Type
