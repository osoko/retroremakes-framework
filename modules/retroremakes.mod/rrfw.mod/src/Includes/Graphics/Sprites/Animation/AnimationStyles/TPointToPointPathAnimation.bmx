'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TPointToPointPathAnimation Extends TSpriteAnimation

	Field startX:Float
	Field startY:Float
	Field endX:Float
	Field endY:Float

	Field transitionTime:Int
	
	Field tStep:float

	Field t:Float
	
	Method Reset()
		t = 0.0
		Super.Reset()
	End Method
	
	Method SetTransitionTime(time:Float)
		tStep = (1.0 / time) * (1000 / TFixedTimestep.GetInstance().GetUpdateFrequency())
		t = 0.0
	End Method
	
	Method SetStartPosition(x:Float, y:Float)
		startX = x
		startY = y
	End Method
	
	Method SetEndPosition(x:Float, y:Float)
		endX = x
		endY = y
	End Method	
	
	Method Update:Int(sprite:TSprite)
		t:+tStep
		If t > 1.0
			t = 1.0
			isFinished = True
		EndIf
		sprite.currentPosition_.x = startX + (endX - startX) * t
		sprite.currentPosition_.y = startY + (endY - startY) * t
		Return Finished()
	End Method

End Type
