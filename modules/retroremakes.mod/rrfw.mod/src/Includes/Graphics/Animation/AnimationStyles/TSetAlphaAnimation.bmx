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
		isFinished = True
		Return Finished()
	End Method

End Type
