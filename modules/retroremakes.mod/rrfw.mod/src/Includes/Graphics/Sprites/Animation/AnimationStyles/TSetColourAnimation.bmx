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
