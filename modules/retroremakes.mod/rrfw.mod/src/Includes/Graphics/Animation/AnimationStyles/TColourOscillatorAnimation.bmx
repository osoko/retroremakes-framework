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
	bbdoc: Sprite animation style for applying colour oscillations.
End Rem
Type TColourOscillatorAnimation Extends TAnimation

	Const DEFAULT_COLOURGEN_OFFSET:Float = 0.0
	
	Field colourGen:TColourGen
	Field offset:Float
	Field ignoreAlpha:Int
	
	Method New()
		Self.colourGen = New TColourGen
		Self.offset = DEFAULT_COLOURGEN_OFFSET
		Self.ignoreAlpha = False
	End Method
	
	Method SetIgnoreAlpha(ignoreAlpha:Int = True)
		Self.ignoreAlpha = ignoreAlpha
	End Method
	
	Method SetOffset(offset:Float)
		Self.offset = offset
	End Method

	Method SetColourGen(colourGen:TColourGen)
		Self.colourGen = colourGen
	End Method
	
	Method Update:Int(actor:TActor)
		Local colour:TColourRGB = TColourOscillator.GetInstance().GenColours(colourGen, offset)
		
		actor.colour.r = colour.r
		actor.colour.g = colour.g
		actor.colour.b = colour.b
		
		If Not ignoreAlpha
			actor.colour.a = colour.a
		EndIf

		Return Finished()
	End Method

End Type
