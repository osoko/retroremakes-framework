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
	bbdoc: Sprite animation style for un-hiding sprites.
	about: Makes the sprite visible.
End Rem
Type TMakeVisibleAnimation Extends TAnimation

	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TMakeVisibleAnimation = New TMakeVisibleAnimation
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		actor.SetVisible(True)
		
		SetFinished(True)
		
		Return IsFinished()
	End Method

End Type
