Rem
	bbdoc: Message payload containing information about a joystick devices current state.
	about: The #TJoystickMessageData object is used by the #TJoystick input device handler
	to pass messages about the current polled joystick state via the #TMessageService Service.
End Rem
Type TJoystickMessageData Extends TMessageData
	
	' Which joystick port is this?
	Field port:Int
	
	' The number of buttons on this joystick
	Field nButtons:Int
	
	' The available axis on this joystick
	Field availableAxis:Int
	
	' First we have the current status of the buttons
	Field buttonDown:Int[]
	Field buttonHit:Int[]
	
	' Then we have the current status of the axis
	Field joystickX:Float
	Field joystickY:Float
	Field joystickZ:Float
	Field joystickR:Float
	Field joystickU:Float
	Field joystickV:Float
	Field joystickYaw:Float
	Field joystickPitch:Float
	Field joystickRoll:Float
	Field joystickHat:Float
	Field joystickWheel:Float
	
End Type
