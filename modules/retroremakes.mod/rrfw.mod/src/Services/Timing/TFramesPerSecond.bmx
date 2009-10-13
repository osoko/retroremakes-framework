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

rem
	bbdoc: Calculate and Display Frames Per Second performance.
	about: #TFramesPerSecond a #TGameService that calculates and optionally
	displays the FPS performance of the running engine.
endrem
Type TFramesPerSecond Extends TGameService
	
	' Display modes
	Const FPS_DISPLAY_NORMAL:Int = 0
	Const FPS_DISPLAY_OFF:Int = 1
	Const FPS_DISPLAY_VERBOSE:Int = 2
	
	' Display positions
	Const FPS_POSITION_BOTTOM_LEFT:Int = 0
	Const FPS_POSITION_BOTTOM_RIGHT:Int = 1
	Const FPS_POSITION_TOP_LEFT:Int = 2
	Const FPS_POSITION_TOP_RIGHT:Int = 3

	
	rem
		bbdoc: Current FPS
	endrem
	Global fps:Int

		
	rem
		bbdoc: Average FPS
	endrem	
	Global fpsAvg:Int
	
	
	rem
		bbdoc: Counter used during the calculation of the current FPS
	endrem	
	Global fpsCounter:Int
	
	
	rem
		bbdoc: Flag used to skip first calculation when there is not enough data to
		perform the calculation
	endrem		
	Global fpsFirstCalc:Int
	
	
	rem
		bbdoc: The time the last calculation was performed
	endrem		
	Global fpsLastTime:Int = MilliSecs()
	
	
	rem
		bbdoc: The maximum FPS that has been achieved
	endrem		
	Global fpsMax:Int
	
	
	rem
		bbdoc: The minimum FPS that has been achieved
		about: We set it to a large to start with to ensure we get a realistic value
		after the first calculation
	endrem		
	Global fpsMin:Int
	
	
	rem
		bbdoc: The time we started monitoring the FPS
		about: Used in the calculations for average FPS
	endrem	
	Global fpsStartTime:Int = MilliSecs()
	
	
	rem
		bbdoc: The total frame count
	endrem	
	Global fpsTotalFrames:Int = 0
	
	
	rem
		bbdoc: The #TFramesPerSecond service instance
		about: #TFramesPerSecond is a @{Singleton Type} and when it is instantiated this @Global holds
		a reference to the instance
	endrem		
	Global instance:TFramesPerSecond
	
		
	rem
		bbdoc: The colour to use for the FPS display font
	endrem
	Field displayColour:TColourRGB = New TColourRGB
 
	
	rem
		bbdoc: The font to use for the FPS display
	endrem
	Field displayFont:TImageFont

	
	rem
		bbdoc: The display mode to use for the FPS counts
		about: The display can be set to one of the following values:
		<table>
			<tr>
				<th>Display Mode</th>
				<th>Description</th>
			</tr>
			<tr>
				<td>FPS_DISPLAY_NORMAL</td>
				<td>Display the current FPS as a simple number [default]</td>
			</tr>			
			<tr>
				<td>FPS_DISPLAY_OFF</td>
				<td>Don't display a FPS counter</td>
			</tr>	
			<tr>
				<td>FPS_DISPLAY_VERBOSE</td>
				<td>
					Display the current FPS along with the average, minimum and maximum values
					in the format: FPS (Average/Minimum/Maximum)				
				</td>
			</tr>					
		</table>
	endrem
	Field displayMode:Int = FPS_DISPLAY_NORMAL


	rem
		bbdoc: Where the FPS display should be positioned
		about: The position can be set to one of the following values:
		<table>
			<tr>
				<th>Position</th>
				<th>Description</th>
			</tr>
			<tr>
				<td>FPS_POSITION_BOTTOM_LEFT</td>
				<td>Bottom left of the screen</td>
			</tr>			
			<tr>
				<td>FPS_POSITION_BOTTOM_RIGHT</td>
				<td>Bottom right of the screen [default]</td>
			</tr>	
			<tr>
				<td>FPS_POSITION_TOP_LEFT</td>
				<td>Top left of the screen.</td>
			</tr>			
			<tr>
				<td>FPS_POSITION_TOP_RIGHT</td>
				<td>Top right of the screen</td>
			</tr>					
		</table>
	endrem	
	Field displayPosition:Int = FPS_POSITION_TOP_LEFT

	
	
	rem
		bbdoc: This method handles rendering the FPS display to the screen
		about: This is overriden from #TGameService, see the documentation for
		that class for more details
	endrem
	Method DebugRender()
	
		TRenderState.Push()
		
		Local font:TImageFont = GetDisplayFont()
		If font
			SetImageFont(font)
		End If
		
		GetDisplayColour().Set()
		
		Local displayMode:Int = GetDisplayMode()
		
		If Not (displayMode = FPS_DISPLAY_OFF)
		
			Local displayFps:String
			
			Select displayMode
				Case FPS_DISPLAY_NORMAL
					displayFps = GetDisplayFps()
				Case FPS_DISPLAY_VERBOSE
					displayFps = GetDisplayFpsVerbose()
			End Select
					
			Local x:Float
			Local y:Float
			
			Select GetDisplayPosition()
				Case FPS_POSITION_BOTTOM_LEFT
					x = 0.0
					y = TProjectionMatrix.GetInstance().GetHeight() - Float(TextHeight(displayFps))
				Case FPS_POSITION_BOTTOM_RIGHT
					x = TProjectionMatrix.GetInstance().GetWidth() - Float(TextWidth(displayFps))
					y = TProjectionMatrix.GetInstance().GetHeight() - Float(TextHeight(displayFps))
				Case FPS_POSITION_TOP_LEFT
					x = 0.0
					y = 0.0
				Case FPS_POSITION_TOP_RIGHT
					x = TProjectionMatrix.GetInstance().GetWidth() - Float(TextWidth(displayFps))
					y = 0.0
				Default
					x = 0.0
					y = 0.0
			End Select
			
			DrawText(displayFps, x, y)
			
		EndIf
		
		TRenderState.Pop()
		
	End Method
	
	
	
	Rem
		bbdoc: Get the displayColour value in this TFramesPerSecond object.
	End Rem
	Method GetDisplayColour:TColourRGB()
		Return Self.displayColour
	End Method
	
	
	
	Rem
		bbdoc: Get the displayFont value in this TFramesPerSecond object.
	End Rem
	Method GetDisplayFont:TImageFont()
		Return Self.displayFont
	End Method
	
	
				
	rem
		bbdoc: Get a string representation of the current FPS to display in normal mode
	endrem	
	Method GetDisplayFps:String()
		Return "FPS: " + fps
	End Method
	
	
	
	rem
		bbdoc: Get a string representation of the current, average, minimum and
		maximum FPS to display in verbose mode
	endrem	
	Method GetDisplayFpsVerbose:String()
		Return fps + " (" + fpsAvg + "/" + fpsMin + "/" + fpsMax + ")"
	End Method
	
	
	
	Rem
		bbdoc: Get the displayMode value in this TFramesPerSecond object.
	End Rem
	Method GetDisplayMode:Int()
		Return Self.displayMode
	End Method
	
	
	
	Rem
		bbdoc: Get the displayPosition value in this TFramesPerSecond object.
	End Rem
	Method GetDisplayPosition:Int()
		Return Self.displayPosition
	End Method
	
	
			
	rem
		bbdoc: Get a string representation of the average, minimum andmaximum FPS.
	endrem
	Method GetFpsTotals:String()
		Return "Average:" + fpsAvg + "  Minimum:" + fpsMin + "  Maximum:" + fpsMax
	End Method	

	
	
	rem
		bbdoc: Return an instance of #TFramesPerSecond
		returns: #TFramesPerSecond
		about: Returns a new instance of #TFramesPerSecond, or if one already exists returns that instance instead
	endrem	
	Function GetInstance:TFramesPerSecond()
		If Not instance
			Return New TFramesPerSecond
		Else
			Return instance
		EndIf
	EndFunction



	rem
		bbdoc: This function is added as a FlipHook and handles the calculation of
		the FPS statistics
	endrem	
	Function Hook:Object(id:Int, data:Object, context:Object)
		If id = FlipHook
			If fpsTotalFrames = 0
				fpsStartTime = MilliSecs()
			End If
			fpsCounter:+1
			fpsTotalFrames:+1
			Local time:Int = MilliSecs()
			If time - fpsLastTime >= 1000
				fps = fpsCounter
				fpsCounter = 0
				fpsLastTime = time
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
	
	
	
	rem
		bbdoc: Initialises the #TFramesPerSecond service
		about: This is overriden from #TGameService, see the documentation for
		that class for more details		
	endrem	
	Method Initialise()
		SetName("FPS Counter")
		AddHook(FlipHook, TFramesPerSecond.Hook, Null, 10000)
		Reset()
		Super.Initialise()
	End Method

	
	
	rem
		bbdoc: Constructor
	endrem
	Method New()
		If instance rrThrow ("Cannot create multiple instances of this Singleton Type")
		instance = Self
		Self.Initialise()
	EndMethod
		

	
	rem
		bbdoc: Resets the #TFramesPerSecond counters and statistics to starting values
	endrem		
	Method Reset()
		fps = 0
		fpsMax = 0
		fpsMin = 65535
		fpsAvg = 0
		fpsCounter = 0
		fpsTotalFrames = 0
		fpsFirstCalc = 1
	End Method
		
	
	
	Rem
		bbdoc: Set the displayColour value for this TFramesPerSecond object.
	End Rem
	Method SetDisplayColour(value:TColourRGB)
		Self.displayColour = value
	End Method
	
	
		
	Rem
		bbdoc: Set the displayFont value for this TFramesPerSecond object.
	End Rem
	Method SetDisplayFont(value:TImageFont)
		Self.displayFont = value
	End Method
	
	
		
	Rem
		bbdoc: Set the displayMode value for this TFramesPerSecond object.
	End Rem
	Method SetDisplayMode(value:Int)
		Self.displayMode = value
	End Method
	
	
		
	Rem
		bbdoc: Set the displayPosition value for this TFramesPerSecond object.
	End Rem
	Method SetDisplayPosition(value:Int)
		Self.displayPosition = value
	End Method
	
	
		
	rem
		bbdoc: Shutdown the #TFramesPerSecond service
		about: This is overriden from #TGameService, see the documentation for
		that class for more details. This also writes the statistics to the game
		logfile.
	endrem		
	Method Shutdown()
		TLogger.GetInstance().LogInfo("[" + toString() + "] Statistics: " + GetFpsTotals())
		Super.Shutdown()
	End Method
	
	
	
	rem
		bbdoc: Starts the #TFramesPerSecond service
	endrem		
	Method Start()
		Reset()
	End Method
	
EndType
