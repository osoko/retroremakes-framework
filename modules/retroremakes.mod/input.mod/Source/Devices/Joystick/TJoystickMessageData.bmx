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
	bbdoc: Message payload containing information about a joystick devices current state.
	about: The #TJoystickMessageData object is used by the #TJoystick input device handler
	to pass messages about the current polled joystick state via the #TMessageService Service.
End Rem
Type TJoystickMessageData Extends TMessageData
	
	rem
		bbdoc:The available axis on this joystick 
	endrem
	Field availableAxis:Int
	
	rem
		bbdoc: The button down status of all buttons
	endrem
	Field buttonDown:Int[]
	
	rem
		bbdoc: The button hit status of all buttons
	endrem	
	Field buttonHit:Int[]
		
	rem
		bbdoc: The number of buttons the joystick has available
	endrem
	Field nButtons:Int
		
	rem
		bbdoc: The port the joystick is attached to
	endrem
	Field port:Int
	
	rem
		bbdoc: The current status of the joystick Hat
	endrem
	Field joystickHat:Float
	
	rem
		bbdoc: The current status of the joystick Pitch axis
	endrem	
	Field joystickPitch:Float
	
	rem
		bbdoc: The current status of the joystick R axis
	endrem		
	Field joystickR:Float
	
	rem
		bbdoc: The current status of the joystick Roll axis
	endrem		
	Field joystickRoll:Float
	
	rem
		bbdoc: The current status of the joystick U axis
	endrem		
	Field joystickU:Float
	
	rem
		bbdoc: The current status of the joystick V axis
	endrem		
	Field joystickV:Float
	
	rem
		bbdoc: The current status of the joystick Wheel axis
	endrem		
	Field joystickWheel:Float
	
	rem
		bbdoc: The current status of the joystick X axis
	endrem		
	Field joystickX:Float
	
	rem
		bbdoc: The current status of the joystick Y axis
	endrem		
	Field joystickY:Float
	
	rem
		bbdoc: The current status of the joystick Yaw axis
	endrem		
	Field joystickYaw:Float
	
	rem
		bbdoc: The current status of the joystick Z axis
	endrem		
	Field joystickZ:Float
	
End Type
