Rem
	bbdoc: Sprite animation style for adding delays to animations.
	about: Allows you to delay the following animation for a set period of time.
End Rem
Type TDelayedAnimation Extends TAnimation

	Const DEFAULT_DELAY_TIME:Int = 10000 ' in ms
	Field delayTime:Int
	Field startTime:Int
	Field animation:TAnimation

	Method New()
		Self.delayTime = DEFAULT_DELAY_TIME
	End Method
			
	Method SetDelayTime(delayTime:Int)
		Self.delayTime = delayTime
	End Method
	
	Method SetAnimation(animation:TAnimation)
		Self.animation = animation
	End Method
	
	Method remove()
		If animation
			animation.remove()
			animation = Null
		End If
	End Method
	
	Method Reset()
		startTime = Null
		animation.Reset()
		Super.Reset()
	End Method
	
	Method Update:Int(sprite:TActor)
		If Not startTime Then startTime = MilliSecs()
		If MilliSecs() > startTime + delayTime
			If animation
				isFinished = animation.Update(sprite)
			Else
				' If you don't set an animation, this can be purely used to delay
				' a Sequential list of animations, etc.
				isFinished = True
			EndIf
		End If
		Return Finished()
	End Method

End Type
