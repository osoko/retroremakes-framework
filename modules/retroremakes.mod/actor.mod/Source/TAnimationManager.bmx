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
	bbdoc: Class for managing actor animations.
End Rem
Type TAnimationManager

	' The actor that this animation manager is linked to
	Field _actor:TActor

	' The list of animations scheduled for this actor
	Field _animations:TList

	' The list of animations scheduled for this actor that have finished
	Field _finishedAnimations:TList



	rem
		bbdoc: Add an animation
		about: The animation is added to the end of the list of scheduled animations
	endrem
	Method AddAnimation(animation:TAnimation)
		_animations.AddLast(animation)
	End Method



	' Default constructor
	Method New()
		_animations = New TList
		_finishedAnimations = New TList
	End Method



	rem
		bbdoc: Removes all animations
		about: Calls each animations Remove() method so that any additional
		tidying up can be done by the animations themselves
	endrem
	Method RemoveAnimations()
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
		bbdoc: Resets scheduled animations
		about: This calls the Reset() method of each animation
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
	End Method



	rem
		bbdoc: Set the actor that this animation manager is lined to
	endrem
	Method SetActor(value:TActor)
		_actor = value
	End Method



	rem
		bbdoc: Update all animations
		about: Once an animation has finished it is removed from the list and added
		to a list of finished animations
	endrem
	Method Update()
		If Not _actor Then Throw "TAnimationManager has no TActor attached"
		If _animations.Count() > 0
			If TAnimation(_animations.First()).Update(_actor)
				'Animation has finished so remove it
				_finishedAnimations.AddLast(_animations.RemoveFirst())
			EndIf
		End If
	End Method
	
End Type
