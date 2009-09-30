'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TMakeVisibleAnimation Extends TSpriteAnimation

	Method Update:Int(sprite:TSprite)
		sprite.SetVisible(True)
		isFinished = True
		Return Finished()
	End Method

End Type
