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

	' The alpha value to set the actor to when this animation is run
	Field _alpha:Float
	
	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TSetAlphaAnimation = New TSetAlphaAnimation
		animation._alpha = _alpha
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Set the alpha value to use in this animation
	endrem
	Method SetAlpha(value:Float)
		_alpha = value
	End Method
	
	
	
	rem
		bbdoc: Updates the animation
	endrem
	Method Update:Int(sprite:TActor)
		sprite.GetColour().a = _alpha
		
		SetFinished(True)
		
		Return IsFinished()
	End Method

End Type
