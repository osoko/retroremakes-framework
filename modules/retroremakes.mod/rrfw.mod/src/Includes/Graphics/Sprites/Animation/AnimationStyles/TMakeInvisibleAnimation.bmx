'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TMakeInvisibleAnimation Extends TSpriteAnimation

	Method Update:Int(sprite:TSprite)
		sprite.SetVisible(False)
		isFinished = True
		Return Finished()
	End Method

End Type
