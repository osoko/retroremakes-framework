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
	bbdoc: Sprite animation style for timed animations.
	about: Allows you to show an animation for a user-specified period of time.
End Rem
Type TTimedAnimation Extends TAnimation

	' Default animation length in milliseconds
	Const DEFAULT_ANIMATION_LENGTH:Int = 10000
	
	' The animation to run for a certain period of time
	Field _animation:TAnimation
	
	' How long to show the animation for in milliseconds
	Field _animationLength:Int
	
	' When the animation will finish
	Field _finishTime:Int



	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TTimedAnimation = New TTimedAnimation
		animation._animation = _animation.Copy()
		animation._animationLength = _animationLength
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_animationLength = DEFAULT_ANIMATION_LENGTH
	End Method
	
	
	
	rem
		bbdoc: Reset the animation
	endrem
	Method Reset()
		_finishTime = Null
		_animation.Reset()
		Super.Reset()
	End Method
		
	
	
	rem
		bbdoc: Set the animation length in milliseconds
	endrem
	Method SetAnimationLength(time:Int)
		_animationLength = time
	End Method
	
	
	
	rem
		bbdoc: Set the animation to use
	endrem
	Method SetAnimation(animation:TAnimation)
		_animation = animation
	End Method
	
	
	
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		If Not _animation
			Throw "TTimedAnimation does not have an assigned TAnimation"
		EndIf
		
		If Not _finishTime
			_finishTime = MilliSecs() + _animationLength
		EndIf
		
		If _finishTime - MilliSecs() > 0
			_animation.Update(actor)
		Else
			SetFinished(True)
		End If
		
		Return IsFinished()
	End Method
	
End Type
