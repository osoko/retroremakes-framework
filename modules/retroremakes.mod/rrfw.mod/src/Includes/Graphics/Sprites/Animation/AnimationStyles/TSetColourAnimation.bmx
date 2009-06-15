'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSetColourAnimation Extends TSpriteAnimation

	Field colour_:TColourRGB
	
	Method SetColour(colour:TColourRGB)
		colour_ = colour
	End Method
	
	Method Update:Int(sprite:TSprite)
		sprite.SetColour(colour_)
		isFinished = True
		Return Finished()
	End Method

End Type
