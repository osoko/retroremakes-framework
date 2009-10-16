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
	bbdoc: Sprite animation style for settings colours.
	about: Allows you to set the sprite's colour as part of an animation.
End Rem
Type TSetColourAnimation Extends TAnimation

	Field colour_:TColourRGB
	
	Method SetColour(colour:TColourRGB)
		colour_ = colour
	End Method
	
	Method Update:Int(sprite:TActor)
		sprite.SetColour(colour_)
		isFinished = True
		Return Finished()
	End Method

End Type
