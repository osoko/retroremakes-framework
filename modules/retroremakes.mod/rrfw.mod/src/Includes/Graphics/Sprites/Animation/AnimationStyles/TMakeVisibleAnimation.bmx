Rem
	bbdoc: Sprite animation style for un-hiding sprites.
	about: Makes the sprite visible.
End Rem
Type TMakeVisibleAnimation Extends TSpriteAnimation

	Method Update:Int(sprite:TSprite)
		sprite.SetVisible(True)
		isFinished = True
		Return Finished()
	End Method

End Type
