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
