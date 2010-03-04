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
	bbdoc: 
endrem
Type TGraphicsService Extends TGameService
	
	Global instance:TGraphicsService

	Const DEFAULT_DIRECT_X:String = "DirectX7"
	Const DEFAULT_GFX_DEPTH:Int = 32
	Const DEFAULT_GFX_FLAGS:Int = GRAPHICS_BACKBUFFER
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
	
	Const DEFAULT_GFX_PROJECTION_X:Float = 800.0
	Const DEFAULT_GFX_PROJECTION_Y:Float = 600.0
	Const DEFAULT_GFX_PROJECTION_ENABLED:String = "false"
		
	' The drivers that are available for use
	Field _availableDrivers:String[]
	
	' The colour depth we are using
	Field _depth:Int
	
	' This is the graphics device we will be using
	Field _device:TGraphics
	
	' The name of the graphics driver we are using
	Field _driver:String

	' Whether to use fixed point or sub-pixel rendering
	Field _fixedPointRendering:Int

	' Default flags to use when creating our graphics device	
	Field _flags:Int
	
	' The physical display height (not necessarily the game height)
	Field _height:Int

	' A sorted, de-duplicated list of available graphics modes.
	Field _modes:TList = New TList
	
	' A shortcut to the projection matrix
	Field _projectionMatrix:TProjectionMatrix
	
	' The refresh rate of the graphics device we will be using
	Field _refresh:Int
	
	' Whether we will be waiting for vblank before flipping
	Field _vblank:Int
	
	' The physical display width (not necessarily the game width)	
	Field _width:Int

	' Whether to run windowed or full-screen
	Field _windowed:Int



	rem
		bbdoc: Checks to see if the application has been suspended or not.
		about: If it has it will create a temporary timer and use that to yield to
		the system to free up CPU time. Once the application has been resumed, it
		will reset the graphics if it was running in full-screen mode and it will
		also reset the Fixed Timestep and FPS calculations.
	endrem
	Method CheckIfActive()
		If AppSuspended()
			TGameEngine.GetInstance().SetPaused(True)
			Local susTimer:TTimer = CreateTimer(60)  'temporary timer to help free up CPU when game suspended
			'wait until app is active again
			While AppSuspended() 
				WaitTimer(susTimer)   'Do nothing and free up CPU
			Wend
			If Not _windowed
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
	
	
	
	rem
		bbdoc: De-Duplicates a list of TGraphicsMode objects
	endrem
	Method DeDuplicateGraphicsModes:TList(modes:TList)
		Local deDupedModes:TList = New TList
		
		Local First:Int = True
		
		For Local mode:TGraphicsMode = EachIn modes
			If first
				deDupedModes.AddLast(mode)
				First = False
			Else
				If GraphicsModeSort(deDupedModes.Last(), mode) <> 0
					deDupedModes.AddLast(mode)
				End If
			End If
		Next
		
		Return deDupedModes
	End Method
	
	
	
	rem
		bbdoc: Find graphics modes for all available drivers
		about: de-duplicate and exclude modes that are not available on all drivers
	endrem
	Method FindGraphicsModes()
		'Get the OpenGL Modes first	
		SetGraphicsDriver(GLMax2DDriver())
		_modes = ListFromArray(GraphicsModes())
		
		TLogger.GetInstance().LogInfo("[" + toString() + "] OpenGL graphics modes found: " + _modes.Count())
		
		'DirectX modes only if on Windows
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
			For Local FindMode:TGraphicsMode = EachIn dxModes
			
				Local found:Int = False
			
				For Local mode:TGraphicsMode = EachIn _modes
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
			For Local findMode:TGraphicsMode = EachIn _modes
			
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
					_modes.Remove(findMode)
				End If
			Next
			
			'Merge the lists
			For Local mode:TGraphicsMode = EachIn dxModes
				_modes.AddLast(mode)
			Next
		?
		
		' Now sort and deduplicate
		_modes.Sort(True, TGraphicsService.GraphicsModeSort)
		TLogger.GetInstance().LogInfo("[" + toString() + "] Total graphics modes found: " + _modes.Count())
		
		_modes = DeDuplicateGraphicsModes(_modes)
		TLogger.GetInstance().LogInfo("[" + toString() + "] Deduplicated graphics modes found: " + _modes.Count())
	End Method

	
	
	rem
		bbdoc: Get the aspect ratio of the physical display
	endrem
	Method GetAspectRatio:Float()
		Return Float(GetWidth()) / Float(GetHeight())
	End Method
	
	
	
	rem
		bbdoc: Get the names of all available drivers
	endrem
	Method GetAvailableDrivers:String[] ()
		Return _availableDrivers
	End Method
	
	
	
	rem
		bbdoc: Get the colour depth of the graphics device
	endrem
	Method GetDepth:Int()
		Return _depth
	End Method
	
	
	
	rem
		bbdoc: Get the name of the graphics driver
	endrem		
	Method GetDriver:String()
		Return _driver
	End Method
	
	

	rem
		bbdoc: Get the height of the graphics device
		about: This value is the physical display height and may not be the same as
		the game resolution if you are using the projection matrix
	endrem		
	Method GetHeight:Int()
		Return _height
	End Method
	
	
	
	rem
		bbdoc: Get the TGraphicsService instance
		about: The graphics service is a Singleton class, use this to gain access
		to its instance
	endrem
	Function GetInstance:TGraphicsService()
		If Not instance
			Return New TGraphicsService
		Else
			Return instance
		EndIf
	EndFunction

	
	
	rem
		bbdoc: Get the available graphics modes
		about: This is a sorted, de-duplicated list of available TGraphicsMode
		graphics modes. On Windows, only modes available in both OpenGL and DirectX
		drivers are included.
	endrem
	Method GetModes:TList()
		Return _modes
	End Method
	
	
	
	rem
		bbdoc: Get the refresh rate of the graphics device
	endrem
	Method GetRefresh:Int()
		Return _refresh
	End Method
	
	
	
	rem
		bbdoc: Whether VBlank is enabled or not
	endrem
	Method GetVBlank:Int()
		Return _vblank
	End Method
	
	
	
	rem
		bbdoc: Get the width of the graphics device
		about: This value is the physical display width and may not be the same as
		the game resolution if you are using the projection matrix
	endrem	
	Method GetWidth:Int()
		Return _width
	End Method
	
	
	
	rem
		bbdoc: Get whether we are running windowed or full-screen
		returns: true if running in a window, otherwise false
	endrem
	Method GetWindowed:Int()
		Return _windowed
	End Method
	
	
	
	rem
		bbdoc: Used to sort TGraphicsMode objects
	endrem
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
	
	
	
	Rem
		bbdoc:Initialise the #TGameService instance.
	End Rem
	Method Initialise()
		SetFlags(DEFAULT_GFX_FLAGS)
		SetName("Graphics Service")
		
		'has to be the first service to startas other services may rely on the
		'Graphics Device
		startPriority = -9999
		
		?Win32
			_availableDrivers = New String[3]
			_availableDrivers[0] = "DirectX7"
			_availableDrivers[1] = "DirectX9"
			_availableDrivers[2] = "OpenGL"
		?Not Win32
			_availableDrivers = New String[1]
			_availableDrivers[0] = "OpenGL"
		?
		
		_projectionMatrix = TProjectionMatrix.GetInstance()
		
		SetFixedPointRendering(True)
		TMessageService.GetInstance().CreateMessageChannel(CHANNEL_GRAPHICS, "Graphics Service")
		Super.Initialise()
	End Method
		
	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		If instance rrThrow "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
	
	
	
	rem
		bbdoc: Set the configured graphics mode
		about: This will destroy any existing graphics device and recreate it.  Any
		entries on the render state stack will also be cleared.
	endrem	
	Method Set()
	
		'Kill the existing graphics device if it exists
		If _device
			TLogger.GetInstance().LogInfo("[" + toString() + "] Closing existing Graphics device")
			DisablePolledInput()
			
			CloseGraphics(_device)
			_device = Null
		End If

		Select GetDriver().ToUpper()
			?Win32
				Case "DIRECTX7"
					TLogger.GetInstance().LogInfo("[" + toString() + "] Enabling DirectX7 graphics driver")
					SetGraphicsDriver(D3D7Max2DDriver())
				Case "DIRECTX9"
					TLogger.GetInstance().LogInfo("[" + toString() + "] Enabling DirectX9 graphics driver")
					SetGraphicsDriver(D3D9Max2DDriver())
			?
				Case "OPENGL"
					TLogger.GetInstance().LogInfo("[" + toString() + "] Enabling OpenGL graphics driver")
					GLShareContexts()
					SetGraphicsDriver(GLMax2DDriver())				
		End Select
		
		If _windowed
			TLogger.GetInstance().LogInfo("[" + toString() + "] Attempting to set windowed graphics mode: " + _width + "x" + _height)
			_device = CreateGraphics(_width, _height, 0, 60, _flags)
		Else
			TLogger.GetInstance().LogInfo("[" + toString() + "] Attempting to set full-screen graphics mode: " + _width + "x" + _height + "x" + _depth + "@" + _refresh + "Hz")
			_device = CreateGraphics(_width, _height, _depth, _refresh, _flags)
		EndIf
		
		If Not _device
			rrThrow "Requested graphics mode unavailable: " + _width + "x" + _height + "x" + _depth + "@" + _refresh + "Hz"
		EndIf
		
		brl.Graphics.SetGraphics(_device)
			
		If _projectionMatrix.IsEnabled()
			_projectionMatrix.Set()
		End If
		
		EnablePolledInput()
		
		' Clear any render states on the stack, as they may now have invalid viewport values
		TRenderState.Clear()
		
		TFramesPerSecond.GetInstance().Reset()
		
		Local message:TMessage = New TMessage
		message.SetMessageId(MSG_GRAPHICS_RESET)
		message.Broadcast(CHANNEL_GRAPHICS)
	End Method
	
	
	
	rem
		bbdoc: Set the colour depth to use for the graphics device
	endrem
	Method SetDepth(depth:Int)
		_depth = depth
		rrSetIntVariable("GFX_DEPTH", depth, "Engine")
	End Method
	
	
	
	rem
		bbdoc: Set the driver to use for the graphics device
		about: Available drivers are DirectX7, DirectX9 and OpenGL
	endrem	
	Method SetDriver(driver:String)
		Select Driver.ToLower()
			?Win32
				Case "directx"
					_driver = DEFAULT_DIRECT_X
				Case "directx7"
					_driver = "DirectX7"
				Case "directx9"
					_driver = "DirectX9"
			?
				Case "opengl"
					_driver = "OpenGL"
				Default
					?Win32
						_driver = DEFAULT_DIRECT_X
					?Not Win32
						_driver = "OpenGL"
					?
		End Select

		rrSetStringVariable("GFX_DRIVER", _driver, "Engine")
	End Method
	
	
	
	rem
		bbdoc: Set whether to use fixed-point rendering or not
		about: For some game times, sub-pixel rendering can look unpleasant.
		Setting this to true will force all images to be drawn at integer
		coordinates
	endrem	
	Method SetFixedPointRendering(bool:Int)
		_fixedPointRendering = bool
	End Method
	
	
	
	rem
		bbdoc: Set the flags to use for the graphics device
	endrem	
	Method SetFlags(flags:Int)
		_flags = flags
	End Method
	
	
	
	rem
		bbdoc: Set the graphics mode provided
	endrem
	Method SetGraphics(width:Int, height:Int, depth:Int, refresh:Int, windowed:Int, vblank:Int, Driver:String)
		SetDepth(depth)
		SetWidth(width)
		SetHeight(height)
		SetRefresh(refresh)
		SetWindowed(windowed)
		SetVBlank(vblank)
		SetDriver(driver)
		Set()
	End Method
	
	
		
	rem
		bbdoc: Set the height to use for the graphics device
	endrem		
	Method SetHeight(height:Int)
		_height = height
		rrSetIntVariable("GFX_Y", height, "Engine")
	End Method

	
	
	rem
		bbdoc: Set the refresh rate to use for the graphics device
	endrem	
	Method SetRefresh(refresh:Int)
		_refresh = refresh
		rrSetIntVariable("GFX_REFRESH", refresh, "Engine")
	End Method		

	
	
	rem
		bbdoc: Set whether to wait for vblank on flip or not
	endrem	
	Method SetVBlank(vblank:Int)
		If vblank
			rrSetBoolVariable("GFX_VBLANK", "true", "Engine")
		Else
			rrSetBoolVariable("GFX_VBLANK", "false", "Engine")
		End If
		_vblank = vblank
	End Method
	
	
	
	rem
		bbdoc: Set the width to use for the graphics device
	endrem	
	Method SetWidth(width:Int)
		_width = width
		rrSetIntVariable("GFX_X", width, "Engine")
	End Method

	
	
	rem
		bbdoc: Set whether to use a window or full-screen for the graphics device
	endrem	
	Method SetWindowed(windowed:Int)
		If windowed
			rrSetBoolVariable("GFX_WINDOWED", "true", "Engine")
		Else
			rrSetBoolVariable("GFX_WINDOWED", "false", "Engine")
		End If
		_windowed = windowed
	End Method


	
	Rem
		bbdoc: Shuts down the #TGameService instance
	End Rem
	Method Shutdown()
		If _device
			CloseGraphics(_device)
			_device = Null
		End If
		Super.Shutdown()
	End Method



	rem
		bbdoc: Called at service start
		about: Sets the graphics driver to either the defaults, or values stored
		in the INI file. Also generates a list of available graphics modes
	endrem		
	Method Start()
		SetWidth(rrGetIntVariable("GFX_X", DEFAULT_GFX_X, "Engine"))
		
		SetDepth(rrGetIntVariable("GFX_DEPTH", DEFAULT_GFX_DEPTH, "Engine"))
		
		SetHeight(rrGetIntVariable("GFX_Y", DEFAULT_GFX_Y, "Engine"))
		
		SetRefresh(rrGetIntVariable("GFX_REFRESH", DEFAULT_GFX_REFRESH, "Engine"))
		
		SetWindowed(rrGetBoolVariable("GFX_WINDOWED", DEFAULT_GFX_WINDOWED, "Engine"))
		
		SetVBlank(rrGetBoolVariable("GFX_VBLANK", DEFAULT_GFX_VBLANK, "Engine"))
		
		SetDriver(rrGetStringVariable("GFX_DRIVER", DEFAULT_GFX_DRIVER, "Engine"))
		
		FindGraphicsModes()
		
		Set()
	End Method


	
	rem
		bbdoc: Whether to use fixed point rendering or not
	endrem
	Method UseFixedPointRendering:Int()
		Return _fixedPointRendering
	End Method
	
End Type



Function rrGetGraphicsSize:TVector2D()
	Local size:TVector2D = New TVector2D
	size.x = Float(rrGetGraphicsWidth())
	size.y = Float(rrGetGraphicsHeight())
	Return size
End Function



Function rrGetGraphicsWidth:Int()
	If TProjectionMatrix.GetInstance().IsEnabled()
		Return rrGetProjectionMatrixWidth()
	Else
		Return TGraphicsService.GetInstance().GetWidth()
	End If
End Function



Function rrGetGraphicsHeight:Int()
	If TProjectionMatrix.GetInstance().IsEnabled()
		Return rrGetProjectionMatrixHeight()
	Else
		Return TGraphicsService.GetInstance().GetHeight()
	End If
End Function



Function rrSetGraphicsWidth(width:Int)
	TGraphicsService.GetInstance().SetWidth(width)
End Function



Function rrSetGraphicsHeight(height:Int)
	TGraphicsService.GetInstance().SetHeight(height)
End Function



Function rrSetGraphicsDepth(depth:Int)
	TGraphicsService.GetInstance().SetDepth(depth)
End Function



Function rrSetGraphicsRefresh(refresh:Int)
	TGraphicsService.GetInstance().SetRefresh(refresh)
End Function



Function rrSetGraphicsWindowed(windowed:Int)
	TGraphicsService.GetInstance().SetWindowed(windowed)
End Function



Function rrSetGraphicsVBlank(vblank:Int)
	TGraphicsService.GetInstance().SetVBlank(vblank)
End Function



Function rrSetGraphicsDriver(driver:String)
	TGraphicsService.GetInstance().SetDriver(Driver)
End Function



Function rrSetNewGraphics(width:Int, height:Int, depth:Int, refresh:Int, windowed:Int, vblank:Int, driver:String)
	TGraphicsService.GetInstance().SetGraphics(width, height, depth, refresh, windowed, vblank, Driver)
End Function



Function rrResetGraphics()
	TGraphicsService.GetInstance().Set()
End Function
