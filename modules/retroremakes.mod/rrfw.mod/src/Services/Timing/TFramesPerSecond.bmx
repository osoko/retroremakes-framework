Const FPS_NONE:Int = 0
Const FPS_DISPLAY:Int = 1
Const FPS_DISPLAY_VERBOSE:Int = 2

Type TFramesPerSecond Extends TGameService

	Global instance:TFramesPerSecond		' This holds the singleton instance of this Type
	
	Global fps:Int = 0
	Global fpsMax:Int = 0
	Global fpsMin:Int = 64738 '(SYS ;) make it stupidly large to start with
	Global fpsAvg:Int = 0
	Global fpsCounter:Int = 0
	Global fpsTotalFrames:Int = 0
	Global fpsTimer:TTimer
	Global fpsStartTime:Int = MilliSecs()
	Global fpsLastTime:Int = MilliSecs()
	Global fpsFirstCalc:Int = 1
	
	Field displayFont:TImageFont
	Field displayPosition:TVector2D = New TVector2D
	Field displayColour:TColourRGB = New TColourRGB
	Field displayMode:Int = FPS_DISPLAY
		
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
		
	Function Create:TFramesPerSecond()
		Return TFramesPerSecond.GetInstance()
	End Function
		
	Function GetInstance:TFramesPerSecond()
		If Not instance
			Return New TFramesPerSecond
		Else
			Return instance
		EndIf
	EndFunction
	
	Method Initialise()
		name = "FPS Counter"
		fpsTimer = CreateTimer(1)
		AddHook(FlipHook, TFramesPerSecond.Hook, Null, 10000)
		Reset()
		Super.Initialise()
	End Method
	
	Method Start()
		Reset()
	End Method
	
	Method Reset()
		fps = 0
		fpsMax = 0
		fpsMin = 64738
		fpsAvg = 0
		fpsCounter = 0
		fpsTotalFrames = 0
		fpsStartTime = MilliSecs()
		fpsFirstCalc = 1
	End Method
		
	Method Shutdown()
		TGameEngine.GetInstance().LogGlobal(GetFPSTotals())
		Super.Shutdown()
	End Method
	
	Method DebugRender()
		If displayFont
			SetImageFont(displayFont)
		End If
		displayColour.Set()
		Select displayMode
			Case FPS_NONE
				' Do nothing
			Case FPS_DISPLAY
				DrawText(GetFPS(), displayPosition.x, displayPosition.y)
			Case FPS_DISPLAY_VERBOSE
				DrawText(GetFPSTotals(), displayPosition.x, displayPosition.y)
		End Select
	End Method
	
	Function Hook:Object(id:Int, data:Object, context:Object)
		If id = FlipHook
			fpsCounter:+1
			fpsTotalFrames:+1
			Local myNowTime:Int = MilliSecs()
			If myNowTime - fpsLastTime >= 1000
				fps = fpsCounter
				fpsCounter = 0
				fpsLastTime = myNowTime
				If Not fpsFirstCalc
					If fps > fpsMax Then fpsMax = fps
					If fps < fpsMin Then fpsMin = fps
					fpsAvg = fpsTotalFrames / ((MilliSecs() - fpsStartTime) / 1000.0)
				Else
					fpsFirstCalc = Null
				EndIf
			EndIf
		EndIf
		Return data
	End Function

	Method GetFPS:Int()
		Return fps
	End Method

	Method GetMaxFPS:Int()
	    Return fpsMax
	End Method
	
	Method GetMinFPS:Int()
	    Return fpsMin
	End Method
	
	Method GetFPSTotals:String()
		Return "FPS (Avg/Min/Max): " + fpsAvg + "/" + fpsMin + "/" + fpsMax
	End Method
	
EndType

Function rrResetFPS()
	TFramesPerSecond.GetInstance().Reset()
End Function

Function rrGetFPS:String()
	Return TFramesPerSecond.GetInstance().GetFPS()
End Function

Function rrGetFPSTotals:String()
	Return TFramesPerSecond.GetInstance().GetFPSTotals()
End Function