'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
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
