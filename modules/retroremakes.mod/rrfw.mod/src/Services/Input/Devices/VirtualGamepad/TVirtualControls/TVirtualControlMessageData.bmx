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
	bbdoc: Message data showing the current state of a virtual control
End Rem
Type TVirtualControlMessageData Extends TMessageData

	' The current analogue status of the control
	Field analogueStatus:Float

	' The name of the control
	Field controlName:String
	
	' The current digital status of the control
	Field digitalStatus:Int
	
	' The ID of the gamepad the control is attached to
	Field gamepadId:Int
	
	' The number of hits registered for the control
	Field hits:Int
	
End Type
