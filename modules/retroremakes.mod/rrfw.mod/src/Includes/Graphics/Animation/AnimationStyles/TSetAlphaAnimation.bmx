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
	bbdoc: Sprite animation style for setting alpha values.
	about: Allows you to set a sprite's alpha channel to the specified value
	as part of an animation.
End Rem
Type TSetAlphaAnimation Extends TAnimation

	Field alpha_:Float
	
	Method SetAlpha(alpha:Float)
		alpha_ = alpha
	End Method
	
	Method Update:Int(sprite:TActor)
		sprite.GetColour().a = alpha_
		SetFinished(True)
		Return IsFinished()
	End Method

End Type
