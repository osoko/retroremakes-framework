'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSetAlphaAnimation Extends TSpriteAnimation

	Field alpha_:Float
	
	Method SetAlpha(alpha:Float)
		alpha_ = alpha
	End Method
	
	Method Update:Int(sprite:TSprite)
		sprite.GetColour().a = alpha_
		isFinished = True
		Return Finished()
	End Method

End Type
