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
	bbdoc: Sprite animation style for timed animations.
	about: Allows you to show an animation for a user-specified period of time.
End Rem
Type TTimedAnimation Extends TAnimation

	Const DEFAULT_ANIMATION_LENGTH:Int = 10000 'default in ms
	
	Field animation:TAnimation
	Field animationLength:Int
	Field finishTime:Int
	
	Method New()
		animationLength:Int = DEFAULT_ANIMATION_LENGTH
	End Method
	
	Method SetAnimationTime(animationLength:Int)
		Self.animationLength = animationLength
	End Method
	
	Method SetAnimation(animation:TAnimation)
		Self.animation = animation
	End Method
	
	Method Reset()
		finishTime = null
		animation.Reset()
		Super.Reset()
	End Method
	
	Method Update:Int(sprite:TActor)
		If Not animation Then Throw "TTimedAnimation does not have an assigned TSpriteAnimation"
		If Not finishTime Then finishTime = MilliSecs() + animationLength
		If finishTime - MilliSecs() > 0
			animation.Update(sprite)
		Else
			SetFinished(True)
		End If
		Return IsFinished()
	End Method
	
End Type
