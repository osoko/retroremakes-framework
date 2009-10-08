Rem
	bbdoc: Sprite animation style for looping animations.
	about: Allows you to assign multiple animations to a sprite and loop through
	them 1 or more times.
End Rem
Type TLoopedAnimation Extends TAnimation

	Const DEFAULT_NUM_LOOPS:Int = -1 '-1 = forever
	
	Field animationLoops:Int
	
	Field animations:TList
	Field finishedAnimations:TList
	
	Field loopsRemaining:Int
	
	Method New()
		animationLoops:Int = DEFAULT_NUM_LOOPS
		loopsRemaining = animationLoops
		animations = New TList
		finishedAnimations = New TList
	End Method
	
	Method SetAnimationLoops(animationLoops:Int)
		Self.animationLoops = animationLoops
	End Method
	
	Method AddAnimation(animation:TAnimation)
		animations.AddLast(animation)
	End Method

	Method LoopAnimation:Int()
		If animations.Count() = 0
			' -1 means we will loop forever, so we always reset the animation list
			If loopsRemaining = -1
				LoopReset()
				Return False	'Not finished
			ElseIf loopsRemaining > 0
				loopsRemaining:-1
				LoopReset()
				Return False	'Not finished
			Else
				'We're finished
				Return True
			End If
		EndIf
	End Method
	
	'used to reset all animations in the loop without affecting the loop counter
	Method LoopReset()

		'move any remaining animations to the finished list
		While animations.Count() > 0
			finishedAnimations.AddLast(animations.RemoveFirst())
		Wend
		animations.Clear()
		'repopulate animation list and reset all animations
		While finishedAnimations.Count() > 0
			animations.AddLast(finishedAnimations.RemoveFirst())
			TAnimation(animations.Last()).Reset()
		Wend
		finishedAnimations.Clear()					
	End Method
	
	Method remove()
		Local animation:TAnimation
		For animation = EachIn animations
			animation.remove()
			animations.remove(animation)
			animation = Null
		Next
		For animation = EachIn finishedAnimations
			animation.remove()
			finishedAnimations.remove(animation)
			animation = Null
		Next		
	End Method
		
	Method Reset()
		Super.Reset()
		loopsRemaining = animationLoops
		LoopReset()
	End Method
	
	Method Update:Int(sprite:TActor)
		If animations.Count() > 0
			If TAnimation(animations.First()).Update(sprite)
				'Animation has finished so move it to the finished list
				finishedAnimations.AddLast(animations.RemoveFirst())
				If animations.Count() = 0
					isFinished = LoopAnimation()
				EndIf
			EndIf
		EndIf
		Return Finished()
	End Method
	

End Type

