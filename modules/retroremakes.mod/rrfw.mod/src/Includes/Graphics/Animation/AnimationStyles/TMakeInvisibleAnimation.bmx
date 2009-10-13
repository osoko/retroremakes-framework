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
	bbdoc: Sprite animation style for hiding sprites.
	about: Makes the sprite invisible.
End Rem
Type TMakeInvisibleAnimation Extends TAnimation

	Method Update:Int(sprite:TActor)
		sprite.SetVisible(False)
		isFinished = True
		Return Finished()
	End Method

End Type
