Type TScaleOscillator Extends TGameService

	Global instance:TScaleOscillator		' This holds the singleton instance of this Type
	
	Field setScaleProfile:TProfilerSample

	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TScaleOscillator()
		Return TScaleOscillator.GetInstance()
	End Function
	
	Function GetInstance:TScaleOscillator()
		If Not instance
			Return New TScaleOscillator
		Else
			Return instance
		EndIf
	EndFunction
	
	Method Initialise()
		SetName("Scale Oscillator")
		Super.Initialise()
	End Method

	Method Start()
		setScaleProfile = rrCreateProfilerSample("Scale Oscillator")
	End Method
	
	Method SetScaler(sg:TScaleGen, offset:Float = 0.0)
		rrStartProfilerSample(setScaleProfile)
		rrSetScaler(GenScaler(sg, offset))
		rrStopProfilerSample(setScaleProfile)
	End Method
	
	Method GenScaler:Short(sg:TScaleGen, offset:Float)
		Local x:Int
		Local y:Int
		Local frameCount:Float = rrGetUpdateFrameCount()
		
		x = ( sg.x_hi - sg.x_lo ) Shr 1
		y = ( sg.y_hi - sg.y_lo ) Shr 1

		If offset <> 0.0
			x = Int(x * (Sin((frameCount - offset) * sg.x) + 1))
			y = Int(y * (Sin((frameCount - offset) * sg.y) + 1))
		Else
			x = Int(x * (Sin(frameCount * sg.x) + 1))
			y = Int(y * (Sin(frameCount * sg.y) + 1))
		EndIf
		
		x = (x + sg.x_lo) & $ff
		y = (y + sg.y_lo) & $ff
	
		Return rrMakePackedScaler(x, y)
	End Method
	
EndType

Function rrSetOscillatorScale(sg:TScaleGen, offset:Float = 0.0)
	TScaleOscillator.GetInstance().SetScaler(sg, offset)
End Function

Function rrGenOscillatorScale:Short(sg:TScaleGen, offset:Float)
	Return TScaleOscillator.GetInstance().GenScaler(sg, offset)
End Function
