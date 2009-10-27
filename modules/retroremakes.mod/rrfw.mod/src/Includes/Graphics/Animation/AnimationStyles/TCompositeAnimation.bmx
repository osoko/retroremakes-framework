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

	Field Lanimations:TList
	Field LfinishedAnimations:TList
	
	Method New()
		Lanimations = New TList
		LfinishedAnimations = New TList
	End Method
	
	Method AddAnimation(animation:TAnimation)
		Lanimations.AddLast(animation)
	End Method
	
	
	
	Method remove()
		Local animation:TAnimation
		For animation = EachIn Lanimations
			animation.remove()
			Lanimations.remove(animation)
			animation = Null
		Next
		For animation = EachIn LfinishedAnimations
			animation.remove()
			LfinishedAnimations.remove(animation)
			animation = Null
		Next
	End Method
	
	
	
	Method Reset()
		While LfinishedAnimations.Count() > 0
			Lanimations.AddLast(LfinishedAnimations.RemoveFirst())
		WEnd
		For Local animation:TAnimation = EachIn Lanimations
			animation.Reset()
		Next
		Super.Reset()
	End Method
	
	Method Update:Int(sprite:TActor)
		For Local animation:TAnimation = EachIn Lanimations
			If TAnimation(animation).Update(sprite)
				Lanimations.Remove(animation)
				LfinishedAnimations.AddLast(animation)
			End If
		Next
		If Lanimations.Count() = 0
			SetFinished(True)
		End If
		Return IsFinished()
	End Method
	
End Type
