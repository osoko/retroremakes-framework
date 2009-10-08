Rem
	bbdoc: Sprite animation style for moving from one XY position to another.
	about: Allows you to set a start and end position for the sprite and a
	transition time, the animation will then move the sprite at the correct
	speed to get from A to B in the specified time.
End Rem
Type TPointToPointPathAnimation Extends TAnimation

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
	
	Method Update:Int(sprite:TActor)
		t:+tStep
		If t > 1.0
			t = 1.0
			isFinished = True
		EndIf
		sprite.currentPosition.x = startX + (endX - startX) * t
		sprite.currentPosition.y = startY + (endY - startY) * t
		Return Finished()
	End Method

End Type
