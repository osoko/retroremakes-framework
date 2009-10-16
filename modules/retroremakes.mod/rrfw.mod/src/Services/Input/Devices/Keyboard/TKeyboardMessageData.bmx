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
	bbdoc: Message data containing information about a keys current state.
	about: The #TKeyboardMessageData object is used by the #TKeyboard input device handler
	to pass messages about keystate changes via the #TMessageService Service
End Rem
Type TKeyboardMessageData Extends TMessageData
	
	rem
	bbdoc: The ASCII number of the @key that this message is related to
	endrem
	Field key:Int

	rem
	bbdoc: The current state of the @key.  True if the @key is currently down
	endrem
	Field keyState:Int

	rem
	bbdoc: The number of the times @key has been hit since the last update
	endrem
	Field keyHits:Int
End Type