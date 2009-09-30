Rem
	bbdoc: Sprite animation style for applying colour oscillations.
End Rem
Type TColourOscillatorAnimation Extends TSpriteAnimation

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
	
	Method Update:Int(sprite:TSprite)
		Local colour:TColourRGB = TColourOscillator.GetInstance().GenColours(colourGen, offset)
		
		sprite.colour_.r = colour.r
		sprite.colour_.g = colour.g
		sprite.colour_.b = colour.b
		
		If Not ignoreAlpha
			sprite.colour_.a = colour.a
		EndIf

		Return Finished()
	End Method

End Type
