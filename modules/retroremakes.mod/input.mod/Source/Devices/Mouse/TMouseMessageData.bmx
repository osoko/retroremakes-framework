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
	bbdoc: Message data that contains the current state of a mouse.
End Rem
Type TMouseMessageData Extends TMessageData

	rem
		bbdoc: The last mouse X axis position
	endrem	
	Field lastMousePosX:Int
	
	rem
		bbdoc: The last mouse Y axis position
	endrem	
	Field lastMousePosY:Int
	
	rem
		bbdoc: The last mouse Z axis position
	endrem	
	Field lastMousePosZ:Int
	
	rem
		The current button hit values for all mouse buttons
	endrem
	Field mouseHits:Int[4]
		
	rem
		bbdoc: The current mouse X axis position
	endrem
	Field mousePosX:Int
	
	rem
		bbdoc: The current mouse Y axis position
	endrem	
	Field mousePosY:Int
	
	rem
		bbdoc: The current mouse Z axis position
	endrem	
	Field mousePosZ:Int

	rem
		The current button down values for all mouse buttons
	endrem	
	Field mouseStates:Int[4]
	
End Type
