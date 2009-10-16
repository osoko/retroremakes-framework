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
	bbdoc: Class for managing actor animations.
End Rem
Type TAnimationManager
	Field actor:TActor	'The actor that this animation manager is linked to
	Field animations:TList 'List of animations scheduled for this actor
	Field finishedAnimations:TList
	
	field updateProfile:TProfilerSample
	
	Method New()
		animations = New TList
		finishedAnimations = new TList
	End Method
	
	Method SetActor(value:TActor)
		actor = value
	End Method
	
	Method AddAnimation(animation:TAnimation)
		Self.animations.AddLast(animation)
	End Method
	
	Method Update()
		If Not actor Then Throw "TAnimationManager has no TActor attached"
		If animations.Count() > 0
			If TAnimation(animations.First()).Update(actor)
				'Animation has finished so remove it
				finishedAnimations.AddLast(animations.RemoveFirst())
			EndIf
		End If
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
		GCCollect()
	End Method
	
	
	
	Method Reset()
		'move the remaining animations to the finished list
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
	
End Type
