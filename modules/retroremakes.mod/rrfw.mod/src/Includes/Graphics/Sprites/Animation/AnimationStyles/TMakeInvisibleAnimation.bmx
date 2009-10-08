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
