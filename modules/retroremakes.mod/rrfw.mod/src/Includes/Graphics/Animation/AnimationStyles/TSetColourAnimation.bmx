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
