Rem
	bbdoc: Sprite animation style for setting XY position.
	about: Allows you to set the sprite to a specified position as part
	of an animation.
End Rem
Type TSetPositionAnimation Extends TSpriteAnimation
	
	Field x_:Float
	Field y_:Float
	
	Method SetPosition(x:Float, y:Float)
		x_ = x
		y_ = y
	End Method
	
	Method Update:Int(sprite:TSprite)
		sprite.SetPosition(x_, y_)
		isFinished = True
		Return Finished()
	End Method

End Type
