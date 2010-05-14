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
	bbdoc: Message data showing the current state of a virtual control
End Rem
Type TVirtualControlMessageData Extends TMessageData

	rem
		bbdoc: The current analogue status of the control
	endrem
	Field analogueStatus:Float

	rem
		bbdoc: The name of the control
	endrem
	Field controlName:String
	
	rem
		bbdoc: The current digital status of the control
	endrem
	Field digitalStatus:Int
	
	rem
		bbdoc: The ID of the gamepad the control is attached to
	endrem
	Field gamepadId:Int
	
	rem
		bbdoc: The number of hits registered for the control
	endrem
	Field hits:Int
	
End Type
