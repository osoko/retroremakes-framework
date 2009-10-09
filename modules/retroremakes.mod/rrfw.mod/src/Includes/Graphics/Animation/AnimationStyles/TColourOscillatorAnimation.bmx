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
