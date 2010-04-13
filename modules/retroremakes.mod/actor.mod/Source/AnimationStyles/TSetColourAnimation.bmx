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
	bbdoc: Sprite animation style for settings colours.
	about: Allows you to set the actor's colour as part of an animation.
End Rem
Type TSetColourAnimation Extends TAnimation

	' The colour to use for this animation
	Field _colour:TColourRGB
	
	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TSetColourAnimation = New TSetColourAnimation

		animation._colour.r = _colour.r
		animation._colour.g = _colour.g
		animation._colour.b = _colour.b
		animation._colour.a = _colour.a

		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_colour = New TColourRGB
	End Method
	
	
	
	rem
		bbdoc: Set the colour to use for this animation
	endrem
	Method SetColour(colour:TColourRGB)
		_colour = colour
	End Method
	
	
	
	rem
		bbdoc: Updates the animation
	endrem
	Method Update:Int(actor:TActor)
		actor.SetColour(_colour)
		
		SetFinished(True)
		
		Return IsFinished()
	End Method

End Type
