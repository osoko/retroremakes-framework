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
	bbdoc: Message data that contains the current state of a mouse.
End Rem
Type TMouseMessageData Extends TMessageData
	Field mousePosX:Int
	Field mousePosY:Int
	Field mousePosZ:Int

	Field lastMousePosX:Int
	Field lastMousePosY:Int
	Field lastMousePosZ:Int
		
	Field mouseHits:Int[4]
	Field mouseStates:Int[4]
End Type
