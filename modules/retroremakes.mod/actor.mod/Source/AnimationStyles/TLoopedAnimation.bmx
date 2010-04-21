rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Sprite animation style for looping animations.
	about: Allows you to assign multiple animations to a sprite and loop through
	them 1 or more times.
End Rem
Type TLoopedAnimation Extends TAnimation

	' Default number of loops to perform, -1 = forever 
	Const DEFAULT_NUM_LOOPS:Int = -1
	
	' The number of loops to perform
	Field _loopCount:Int
	
	' The active animations in the looop
	Field _animations:TList
	
	' The finished animations in the loop
	Field _finishedAnimations:TList
	
	' The number of loops remaining
	Field _loopsRemaining:Int
	
	
	
	rem
		bbdoc: Add an animation
		about: The provided animation is appended to the animation loop
	endrem
	Method AddAnimation(animation:TAnimation)
		_animations.AddLast(animation)
	End Method
	
	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TLoopedAnimation = New TLoopedAnimation
		
		animation._loopCount = _loopCount
		
		For Local entry:TAnimation = EachIn _finishedAnimations
			animation._finishedAnimations.AddLast(entry.Copy())
		Next
		
		For Local entry:TAnimation = EachIn _animations
			animation._animations.AddLast(entry.Copy())
		Next
		
		animation.Reset()
			
		Return animation
	End Method

	
	
	rem
		 bbdoc: Loops the animation
		 returns: true if all loops have completed, otherwise false
	endrem
	Method LoopAnimation:Int()
		Local finished:Int = False

		' We only need to loop if all animations have finished
		If _animations.Count() = 0
			If _loopsRemaining = -1
				' -1 = loop forever, so we always reset the animation list
				LoopReset()
			ElseIf _loopsRemaining > 0
				' Still some loops remaining
				_loopsRemaining:-1
				LoopReset()
			Else
				'We're finished
				finished = True
			End If
		EndIf

		Return finished
	End Method
	
	
	
	rem
		bbdoc: Resets the animation loop
		about: The loop and all animations in it are reset without affecting the loop counter
	endrem
	Method LoopReset()
		'move any remaining animations to the finished list
		While _animations.Count() > 0
			_finishedAnimations.AddLast(_animations.RemoveFirst())
		Wend

		_animations.Clear()

		'repopulate animation list and reset all animations
		While _finishedAnimations.Count() > 0
			_animations.AddLast(_finishedAnimations.RemoveFirst())
			TAnimation(_animations.Last()).Reset()
		Wend

		_finishedAnimations.Clear()					
	End Method
	
	
				
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_loopCount = DEFAULT_NUM_LOOPS
		_loopsRemaining = _loopCount
		_animations = New TList
		_finishedAnimations = New TList
	End Method
	
	
	
	rem
		bbdoc: Remove all animations in the loop
	endrem
	Method Remove()
		Local animation:TAnimation
		
		For animation = EachIn _animations
			animation.Remove()
			_animations.remove(animation)
			animation = Null
		Next
		
		For animation = EachIn _finishedAnimations
			animation.Remove()
			_finishedAnimations.remove(animation)
			animation = Null
		Next		
	End Method
		
	
	
	rem
		bbdoc: Reset the animation
	endrem
	Method Reset()
		_loopsRemaining = _loopCount
		LoopReset()
		Super.Reset()
	End Method
	
	
		
	rem
		bbdoc: Set the amount of loops to perform
	endrem
	Method SetLoopCount(count:Int)
		If count > 0 Or count = -1
			_loopCount = count
			_loopsRemaining = _loopCount
		Else
			Throw "Loop count must be -1 or > 0."
		EndIf	
	End Method
	


	rem
		bbdoc: Updates the animation
	endrem
	Method Update:Int(sprite:TActor)
		If _animations.Count() > 0
			If TAnimation(_animations.First()).Update(sprite)
				'Animation has finished so move it to the finished list
				_finishedAnimations.AddLast(_animations.RemoveFirst())
				If _animations.Count() = 0
					SetFinished(LoopAnimation())
				EndIf
			EndIf
		EndIf
		Return IsFinished()
	End Method

End Type

