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
	bbdoc: Sprite animation style for combining multiple concurrent animations.
	about: Allows you to combine multiple animation styles together that run at
	the same time, for example: Move a sprite from point A to point B whilst using
	the alpha channel to fade it in and animating its image frames.
End Rem
Type TCompositeAnimation Extends TAnimation

	' List of animations in this composite
	Field _animations:TList
	
	' List of finished animations
	Field _finishedAnimations:TList
	
	

	rem
		bbdoc: Add an animation
	endrem
	Method AddAnimation(animation:TAnimation)
		_animations.AddLast(animation)
	End Method
	
	
			
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_animations = New TList
		_finishedAnimations = New TList
	End Method
	

	
	rem
		bbdoc: Remove all animations
	endrem
	Method Remove()
		Local animation:TAnimation
		
		For animation = EachIn _animations
			animation.remove()
			_animations.remove(animation)
			animation = Null
		Next
		
		For animation = EachIn _finishedAnimations
			animation.remove()
			_finishedAnimations.remove(animation)
			animation = Null
		Next
	End Method
	
	
	
	rem
		bbdoc: Reset the animation to starting conditions
	endrem
	Method Reset()
		While _finishedAnimations.Count() > 0
			_animations.AddLast(_finishedAnimations.RemoveFirst())
		WEnd
		For Local animation:TAnimation = EachIn _animations
			animation.Reset()
		Next
		Super.Reset()
	End Method
	
	
	
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		For Local animation:TAnimation = EachIn _animations
			If TAnimation(animation).Update(actor)
				_animations.Remove(animation)
				_finishedAnimations.AddLast(animation)
			End If
		Next
		If _animations.Count() = 0
			SetFinished(True)
		End If
		Return IsFinished()
	End Method
	
End Type
