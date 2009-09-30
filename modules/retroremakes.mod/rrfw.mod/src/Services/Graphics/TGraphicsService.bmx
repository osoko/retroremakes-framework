Type TGraphicsService Extends TGameService
	
	Global instance:TGraphicsService

	Const DEFAULT_DIRECT_X:String = "DirectX7"
	Const DEFAULT_GFX_DEPTH:Int = 16
	Const DEFAULT_GFX_REFRESH:Int = 60
	Const DEFAULT_GFX_VBLANK:String = "false"
	Const DEFAULT_GFX_WINDOWED:String = "true"
	Const DEFAULT_GFX_X:Int = 800
	Const DEFAULT_GFX_Y:Int = 600
	
?Not Win32
	Const DEFAULT_GFX_DRIVER:String = "OpenGL"
?Win32
	Const DEFAULT_GFX_DRIVER:String = DEFAULT_DIRECT_X
?
	
	Field device:TGraphics	'This is the graphics object we will be using
	Field flags:Int = GRAPHICS_BACKBUFFER
			
	Field width:Int
	Field height:Int
	Field depth:Int
	Field hertz:Int
	Field windowed:Int
	Field vblank:Int
	Field Driver:String
	
	' A sorted, de-duplicated list of available graphics modes
	' On Windows, only modes available in both OpenGL and
	' DirectX drivers are included.
	Field modes:TList = New TList
	
	'Field font:TImageFont
	
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
	
	Function Create:TGraphicsService()
		Return TGraphicsService.GetInstance()
	End Function
	
	Method GetDriver:String()
		Return Driver
	End Method
		
	Function GetInstance:TGraphicsService()
		If Not instance
			Return New TGraphicsService
		Else
			Return instance
		EndIf
	EndFunction

	Method Initialise()
		SetName("Graphics Service")
		startPriority = -9999	'has to be first as other services may rely on the Graphics Device
		Super.Initialise()
	End Method

	Method Start()
		width = rrGetIntVariable("GFX_X", DEFAULT_GFX_X, "Engine")
		height = rrGetIntVariable("GFX_Y", DEFAULT_GFX_Y, "Engine")
		depth = rrGetIntVariable("GFX_DEPTH", DEFAULT_GFX_DEPTH, "Engine")
		hertz = rrGetIntVariable("GFX_REFRESH", DEFAULT_GFX_REFRESH, "Engine")
		windowed = rrGetBoolVariable("GFX_WINDOWED", DEFAULT_GFX_WINDOWED, "Engine")
		vblank = rrGetBoolVariable("GFX_VBLANK", DEFAULT_GFX_VBLANK, "Engine")
		SetEngineGraphicsDriver(rrGetStringVariable("GFX_DRIVER", DEFAULT_GFX_DRIVER, "Engine"))
		
		FindGraphicsModes()
		
		Set()
	End Method
	
	Method Set()
		'Kill the existing graphics device if it exists
		If device
			TRenderState.Push()
			TLogger.GetInstance().LogInfo("[" + toString() + "] Closing existing graphics device")
			DisablePolledInput()
			CloseGraphics(device)
			device = Null
		End If

		GLShareContexts()
			
		?win32
			If Driver.ToUpper() = "DIRECTX7"
				TLogger.GetInstance().LogInfo("[" + toString() + "] Enabling DirectX7 graphics driver")
				SetGraphicsDriver(D3D7Max2DDriver())
			ElseIf Driver.ToUpper() = "DIRECTX9"
				TLogger.GetInstance().LogInfo("[" + toString() + "] Enabling DirectX9 graphics driver")
				SetGraphicsDriver(D3D9Max2DDriver())
			ElseIf Driver.ToUpper() = "OPENGL"
		?
				TLogger.GetInstance().LogInfo("[" + toString() + "] Enabling OpenGL graphics driver")
				SetGraphicsDriver(GLMax2DDriver())
		?Win32
			EndIf
		?
		
		If windowed
			TLogger.GetInstance().LogInfo("[" + toString() + "] Attempting to set windowed graphics mode: " + width + "x" + height)
			device = CreateGraphics(width, height, 0, 60, flags)
		Else
			TLogger.GetInstance().LogInfo("[" + toString() + "] Attempting to set full-screen graphics mode: " + width + "x" + height + "x" + depth + "@" + hertz + "Hz")
			device = CreateGraphics(width, height, depth, hertz, flags)
		EndIf
		
		If Not device
			Throw "Requested graphics mode unavailable: " + width + "x" + height + "x" + depth + "@" + hertz + "Hz"
		EndIf
		
		SetGraphics(device)
			
		If rrProjectionMatrixEnabled()
			rrCreateProjectionMatrix()
		End If
		
		EnablePolledInput()
		TRenderState.Pop()
		
		TFramesPerSecond.GetInstance().Reset()
	End Method

	Method SetEngineGraphics(	newWidth:Int, newHeight:Int, newDepth:Int, newRefresh:Int,  ..
										newWindowed:Int, newVBlank:Int, newDriver:String)
		SetEngineGraphicsWidth(newWidth)
		SetEngineGraphicsHeight(newHeight)
		SetEngineGraphicsDepth(newDepth)
		SetEngineGraphicsRefresh(newRefresh)
		SetEngineGraphicsWindowed(newWindowed)
		SetEngineGraphicsVBlank(newVBlank)
		SetEngineGraphicsDriver(newDriver)
		Set()
	End Method
		
	Method SetEngineGraphicsWidth(newWidth:Int)
		width = newWidth
		rrSetIntVariable("GFX_X", newWidth, "Engine")
	End Method
	
	Method SetEngineGraphicsHeight(newHeight:Int)
		height = newHeight
		rrSetIntVariable("GFX_Y", newHeight, "Engine")
	End Method
	
	Method SetEngineGraphicsDepth(newDepth:Int)
		depth = newDepth
		rrSetIntVariable("GFX_DEPTH", newDepth, "Engine")
	End Method
	
	Method SetEngineGraphicsRefresh(newRefresh:Int)
		hertz = newRefresh
		rrSetIntVariable("GFX_REFRESH", newRefresh, "Engine")
	End Method			

	Method SetEngineGraphicsWindowed(newWindowed:Int)
		If newWindowed
			rrSetBoolVariable("GFX_WINDOWED", "true", "Engine")
		Else
			rrSetBoolVariable("GFX_WINDOWED", "false", "Engine")
		End If
		windowed = newWindowed
	End Method
	
	Method SetEngineGraphicsVBlank(newVBlank:Int)
		If newVBlank
			rrSetBoolVariable("GFX_VBLANK", "true", "Engine")
		Else
			rrSetBoolVariable("GFX_VBLANK", "false", "Engine")
		End If
		vblank = newVBlank
	End Method
	
	Method SetEngineGraphicsDriver(newDriver:String)
		?Win32
			If newDriver.ToLower() = "directx"
				newDriver = DEFAULT_DIRECT_X
			EndIf
			If newDriver.ToLower() = "directx7"
				Driver = "DirectX7"
			ElseIf newDriver.ToLower() = "directx9"
				Driver = "DirectX9"
			ElseIf newDriver.ToLower() = "opengl"
				Driver = "OpenGL"
			End If
		?Not Win32
			Driver = "OpenGL"
		?
		rrSetStringVariable("GFX_DRIVER", Driver, "Engine")
	End Method

	Method CheckIfActive()
		If AppSuspended()
			TGameEngine.GetInstance().SetPaused(True)
			Local susTimer:TTimer = CreateTimer(60)  'temporary timer to help free up CPU when game suspended
			'wait until app is active again
			While AppSuspended() 
				WaitTimer(susTimer)   'Do nothing and free up CPU
			Wend
			If Not windowed
				'When resuming from minimised full-screen display we need to recreate Grahics
				'and set up the projection matrix again due to DirectX oddness
				TLogger.GetInstance().LogInfo("[" + toString() + "] Resetting graphics mode")
				Set()
			EndIf
			'Reset the fixed timestep timer so we don't have any glitches
			TGameEngine.GetInstance().SetPaused(False)
			rrResetFixedTimestep()
			rrResetFPS()
		EndIf		
	End Method

	' Find graphics modes for all available drivers, de-duplicate
	' and exclude modes that don't appear on both drivers (where
	' available)
	Method FindGraphicsModes()
		'Get the OpenGL Modes first	
		SetGraphicsDriver(GLMax2DDriver())
		modes = ListFromArray(GraphicsModes())
		
		TLogger.GetInstance().LogInfo("[" + toString() + "] OpenGL graphics modes found: " + modes.Count())
		'DirectX modes if on Windows
		?win32
			SetGraphicsDriver(D3D7Max2DDriver())
			Local dxModes:TList = ListFromArray(GraphicsModes())

			SetGraphicsDriver(D3D9Max2DDriver())
			Local dx9Modes:TList = ListFromArray(GraphicsModes())
			
			For Local mode:TGraphicsMode = EachIn dx9Modes
				dxModes.AddLast(mode)
			Next
			
			TLogger.GetInstance().LogInfo("[" + toString() + "] DirectX graphics modes found: " + dxModes.Count())
			'Remove DirectX Modes that aren't available under OpenGL
			
			For Local findMode:TGraphicsMode = EachIn dxModes
				Local found:Int = False
				For Local mode:TGraphicsMode = EachIn modes
					If findMode.width = mode.width And ..
						findMode.height = mode.height And ..
						findMode.depth = mode.depth And ..
						findMode.hertz = mode.hertz
							found = True
							Exit
					End If
				Next
				
				If Not found
					dxModes.Remove(findMode)
				End If
			Next
			
			'Remove OpenGL Modes that aren't available under DirectX
			For Local findMode:TGraphicsMode = EachIn modes
				Local found:Int = False
				For Local mode:TGraphicsMode = EachIn dxModes
					If findMode.width = mode.width And ..
						findMode.height = mode.height And ..
						findMode.depth = mode.depth And ..
						findMode.hertz = mode.hertz
							found = True
							Exit
					End If
				Next
				
				If Not found
					modes.Remove(findMode)
				End If
			Next
			
			'Merge the lists
			For Local mode:TGraphicsMode = EachIn dxModes
				modes.AddLast(mode)
			Next
		?
		
		' Now sort and deduplicate
		modes.Sort(True, TGraphicsService.GraphicsModeSort)
		TLogger.GetInstance().LogInfo("[" + toString() + "] Total graphics modes found: " + modes.Count())
		modes = DeDuplicateGraphicsModes(modes)
		TLogger.GetInstance().LogInfo("[" + toString() + "] Deduplicated graphics modes found: " + modes.Count())
	End Method
	
	Function GraphicsModeSort:Int(o1:Object, o2:Object)
		Local o1mode:TGraphicsMode = TGraphicsMode(o1)
		Local o2mode:TGraphicsMode = TGraphicsMode(o2)

		Local compare:Int

		If o1mode.width < o2mode.width
			compare = -1
		ElseIf o1mode.width > o2mode.width
			compare = 1
		Else
			If o1mode.height < o2mode.height
				compare = -1
			ElseIf o1mode.height > o2mode.height
				compare = 1
			Else
				If o1mode.depth < o2mode.depth
					compare = -1
				ElseIf o1mode.depth > o2mode.depth
					compare = 1
				Else
					If o1mode.hertz < o2mode.hertz
						compare = -1
					ElseIf o1mode.hertz > o2mode.hertz
						compare = 1
					Else
						compare = 0
					End If
				End If
			End If
		End If
		
		Return compare
	End Function
	
	
	Method DeDuplicateGraphicsModes:TList(modes:TList)
		Local deDupedModes:TList = New TList
		Local first:Int = True
		For Local mode:TGraphicsMode = EachIn modes
			If first
				deDupedModes.AddLast(mode)
				first = False
			Else
				If GraphicsModeSort(deDupedModes.Last(), mode) <> 0
					deDupedModes.AddLast(mode)
				End If
			End If
		Next
		Return deDupedModes
	End Method
End Type

Function rrGetGraphicsSize:TVector2D()
	Local size:TVector2D = New TVector2D
	size.x = Float(rrGetGraphicsWidth())
	size.y = Float(rrGetGraphicsHeight())
	Return size
End Function

Function rrGetGraphicsWidth:Int()
	If TProjectionMatrix.GetInstance().enabled
		Return rrGetProjectionMatrixWidth()
	Else
		Return TGraphicsService.GetInstance().width
	End If
End Function

Function rrGetGraphicsHeight:Int()
	If TProjectionMatrix.GetInstance().enabled
		Return rrGetProjectionMatrixHeight()
	Else
		Return TGraphicsService.GetInstance().height
	End If
End Function

Function rrSetGraphicsWidth(width:Int)
	TGraphicsService.GetInstance().SetEngineGraphicsWidth(width)
End Function

Function rrSetGraphicsHeight(height:Int)
	TGraphicsService.GetInstance().SetEngineGraphicsHeight(height)
End Function

Function rrSetGraphicsDepth(depth:Int)
	TGraphicsService.GetInstance().SetEngineGraphicsDepth(depth)
End Function

Function rrSetGraphicsRefresh(refresh:Int)
	TGraphicsService.GetInstance().SetEngineGraphicsRefresh(refresh)
End Function

Function rrSetGraphicsWindowed(windowed:Int)
	TGraphicsService.GetInstance().SetEngineGraphicsWindowed(windowed)
End Function

Function rrSetGraphicsVBlank(vblank:Int)
	TGraphicsService.GetInstance().SetEngineGraphicsVBlank(vblank)
End Function

Function rrSetGraphicsDriver(driver:String)
	TGraphicsService.GetInstance().SetEngineGraphicsDriver(Driver)
End Function

Function rrSetNewGraphics(width:Int, height:Int, depth:Int, refresh:Int, windowed:Int, vblank:Int, driver:String)
	TGraphicsService.GetInstance().SetEngineGraphics(width, height, depth, refresh, windowed, vblank, Driver)
End Function

Function rrResetGraphics()
	TGraphicsService.GetInstance().Set()
End Function
