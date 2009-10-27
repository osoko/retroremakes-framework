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

	Field animations:TList
	Field finishedAnimations:TList
	
	
	
	Method New()
		animations = New TList
		finishedAnimations = New TList
	End Method
	
	
	
	Method AddAnimation(animation:TAnimation)
		animations.AddLast(animation)
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
		Super.Reset()
	End Method
	
	
	
	Method Update:Int(sprite:TActor)
		If animations.Count() > 0
			If TAnimation(animations.First()).Update(sprite)
				'Animation has finished so move it to the finished list
				finishedAnimations.AddLast(animations.RemoveFirst())
				If animations.Count() = 0
					SetFinished(True)
				End If
			EndIf
		Else
			SetFinished(True)
		EndIf
		Return IsFinished()
	End Method

End Type
