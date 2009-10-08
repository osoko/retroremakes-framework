Rem
	bbdoc: Sprite animation style for blinking sprites.
	about: Allows you to blink a sprite on and off at a specified speed.
End Rem
Type TBlinkAnimation Extends TAnimation

	Const DEFAULT_SPEED:Int = 1000	'default in ms

	Field speed:Int
	
	Field startTime:Int
	Field blinkTime:Int
	
	Method New()
		speed = DEFAULT_SPEED
	End Method
	
	Method SetSpeed(speed:Int)
		Self.speed = speed
	End Method

	Method Reset()
		startTime = Null
		blinkTime = Null
		Super.Reset()
	End Method

	Method Update:Int(sprite:TActor)
		If Not startTime Then startTime = MilliSecs()
		Local time:Int = MilliSecs()
		If blinkTime - time < 0
			startTime = time
			blinkTime = startTime + speed

			sprite.SetVisible(Not sprite.IsVisible())
		End If
		Return Finished()
	End Method

End Type
