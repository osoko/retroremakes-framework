Rem
	bbdoc: Sprite animation style for resetting XY position.
	about: Allows you to reset the sprite to a specified position as part
	of an animation.
End Rem
Type TResetPositionAnimation Extends TSetPositionAnimation

	Rem
		bbdoc: Update the animation
	End Rem
	Method Update:Int(actor:TActor)
		actor.ResetPosition(_position.x, _position.y)
		
		SetFinished(True)
		
		Return IsFinished()
	End Method

End Type
