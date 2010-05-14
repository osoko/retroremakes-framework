rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
	bbdoc: Sprite animation style for adding delays to animations.
	about: Allows you to delay the following animation for a set period of time.
End Rem
Type TDelayedAnimation Extends TAnimation

	' Default delay time in milliseconds
	Const DEFAULT_DELAY_TIME:Int = 10000

	' The animation that will be delayed for a period of time before being run
	Field _animation:TAnimation
	
	' The amount of time to delay the animation in milliseconds
	Field _delayTime:Int
	
	' The time that this animation started
	Field _startTime:Int


	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TDelayedAnimation = New TDelayedAnimation
		animation._animation = _animation.Copy()
		animation._delayTime = _delayTime
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_delayTime = DEFAULT_DELAY_TIME
	End Method
	
	
	
	rem
		bbdoc: Remove the delayed animation
	endrem
	Method Remove()
		If _animation
			_animation.Remove()
			_animation = Null
		End If
	End Method
	
	
	
	rem
		bbdoc: Reset the animation
	endrem
	Method Reset()
		_startTime = Null
		_animation.Reset()
		Super.Reset()
	End Method
	
	
		
	rem
		bbdoc: Set the animation that will be run after the delay time has passed
	endrem
	Method SetAnimation(animation:TAnimation)
		_animation = animation
	End Method
	
	
	
	rem
		bbdoc: Set the time to delay the animation for
		about: Value is in milliseconds
	endrem			
	Method SetDelayTime(value:Int)
		_delayTime = value
	End Method
	

	
	rem
		bbdoc: Updates the animation
	endrem
	Method Update:Int(actor:TActor)
		If Not _startTime Then _startTime = MilliSecs()
		
		If MilliSecs() > _startTime + _delayTime
		
			If _animation
				SetFinished(_animation.Update(actor))
			Else
				' If you don't set an animation, this can be used to just delay
				' a sequential list of animations, etc.
				SetFinished(True)
			EndIf
			
		End If
		
		Return IsFinished()
	End Method

End Type
