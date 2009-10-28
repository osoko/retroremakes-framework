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
	bbdoc: Sprite animation style for sequencing one or more animation styles.
	about: Allows you to specify a sequence of animations to play in order.
End Rem
Type TSequentialAnimation Extends TAnimation

	' List of currently active animations
	Field _animations:TList
	
	' List of finished animations
	Field _finishedAnimations:TList
	
	
	
	rem
		bbdoc: Add an animation to the sequence
		about: The provided animation is appended to the sequence
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
			animation.Remove()
			_animations.Remove(animation)
			animation = Null
		Next
		For animation = EachIn _finishedAnimations
			animation.Remove()
			_finishedAnimations.Remove(animation)
			animation = Null
		Next		
	End Method
	
	
		
	rem
		bbdoc: Resets the animation
		about: Also resets all animations in the sequence
	endrem	
	Method Reset()
		'move the remaining animations to the finished list
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
		Super.Reset()
	End Method
	
	
	
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		If _animations.Count() > 0
			If TAnimation(_animations.First()).Update(actor)
				'Animation has finished so move it to the finished list
				_finishedAnimations.AddLast(_animations.RemoveFirst())
				If _animations.Count() = 0
					SetFinished(True)
				End If
			EndIf
		Else
			SetFinished(True)
		EndIf
		
		Return IsFinished()
	End Method

End Type
