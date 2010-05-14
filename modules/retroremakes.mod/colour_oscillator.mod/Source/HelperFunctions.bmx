
Function SetOscillatorColours(cg:TColourGen, offset:Float = 0.0)
	TColourOscillator.GetInstance().SetColours(cg, offset)
End Function

Function SetOscillatorColoursWithoutAlpha(cg:TColourGen, offset:Float = 0.0)
	TColourOscillator.GetInstance().SetColoursWithoutAlpha(cg, offset)
End Function

Function GenOscillatorColours:TColourRGB(cg:TColourGen, offset:Float = 0.0)
	Return TColourOscillator.GetInstance().GenColours(cg, offset)
End Function
