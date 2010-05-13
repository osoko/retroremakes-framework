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
	bbdoc: Sprite animation style for applying colour oscillations.
End Rem
Type TColourOscillatorAnimation Extends TAnimation

	' Default offset to use for the colour oscillator
	Const DEFAULT_COLOURGEN_OFFSET:Float = 0.0
	
	' The colour generator to use for this animation
	Field _colourGen:TColourGen
	
	' Whether to ignore the alpha when updating the actors current colour or not
	Field _ignoreAlpha:Int
	
	' The offest to use when running the colour generator
	Field _offset:Float
	
	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TColourOscillatorAnimation = New TColourOscillatorAnimation
		animation._colourGen = _colourGen
		animation._ignoreAlpha = _ignoreAlpha
		animation._offset = _offset
		animation.Reset()
		Return animation
	End Method

	
	
	' Default constructor
	Method New()
		_colourGen = New TColourGen
		_ignoreAlpha = False
		_offset = DEFAULT_COLOURGEN_OFFSET
	End Method
	
	
	
	rem
		bbdoc: Specify whether to ignore the alpha value in the colour generator or not
	endrem
	Method SetIgnoreAlpha(bool:Int)
		_ignoreAlpha = bool
	End Method
	
	
	
	rem
		bbdoc: Specify the offset to use with the colour generator
	endrem
	Method SetOffset(offset:Float)
		_offset = offset
	End Method

	
	
	rem
		bbdoc: Specify the colour generator to use for this animation
	endrem
	Method SetColourGen(colourGen:TColourGen)
		_colourGen = colourGen
	End Method
	
	
	
	rem
		bbdoc: Update the animation
		about: This generates the colour and applies it to the actor this animation
		is assigned to
	endrem
	Method Update:Int(actor:TActor)
		Local colour:TColourRGB = TColourOscillator.GetInstance().GenColours(_colourGen, _offset)
		
		actor.GetColour().r = colour.r
		actor.GetColour().g = colour.g
		actor.GetColour().b = colour.b
		
		If Not _ignoreAlpha
			actor.GetColour().a = colour.a
		EndIf

		Return IsFinished()
	End Method

End Type
