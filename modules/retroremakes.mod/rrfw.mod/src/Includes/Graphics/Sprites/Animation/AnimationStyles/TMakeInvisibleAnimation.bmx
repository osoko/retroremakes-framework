Rem
	bbdoc: Sprite animation style for hiding sprites.
	about: Makes the sprite invisible.
End Rem
Type TMakeInvisibleAnimation Extends TSpriteAnimation

	Method Update:Int(sprite:TSprite)
		sprite.SetVisible(False)
		isFinished = True
		Return Finished()
	End Method

End Type
