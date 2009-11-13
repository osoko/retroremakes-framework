' Simple Max Application Framework by Doug Stastny (dstastny@comcast.net)
' Uses event driver mechanism to create FPS indenpendent logic/render loop
SuperStrict
Import dbs.d3d9max2d
Import brl.eventqueue
Import brl.timer

Type TMaxApplication
	Field _Terminate : Int
	Field _DisplayWidth:Int=800
	Field _DisplayHeight:Int=600
	Field _DisplayDepth :Int=32
	Field _FullScreen:Int=False
	Field _LogicFPS:Int=60

	Field _lastFlipTime:Int=MilliSecs()
	Field _FPS :Int
	Field _MAXFPS:Int
	Field _LogicTimer : TTimer
	Field _ShowHelp:Int=True
	Field _ShowStats:Int=True
	Field _VSync:Int=False
	Field _VSyncText:String="On"
	Field _SyncGPUText:String="Off"
	Field _Cursor : TImage
	Field _CursorX: Float
	Field _CursorY: Float
      Field _CursorShow :Int

	

	Function _FlipHook:Object( id:Int,data:Object,context:Object )
		Global count:Int=1
		Local app:TMaxApplication=TMaxApplication(context)
		If (app)		
			If (MilliSecs()-app._lastFlipTime)>1000
				app._lastFlipTime=MilliSecs()
				app._FPS=count
				If app._FPS>app._MAXFPS Then app._MAXFPS=app._FPS
				count=1
			Else
				count:+1
			End If	
		End If
		Return data
	End Function

    Function _EventHook:Object(id:Int,data:Object,context:Object)
		Local app:TMaxApplication=TMaxApplication(context)
		If (app) app.OnEvent(TEvent(data))
		Return data
	End Function
	
	Method New()    	
		
	End Method
	
	Method HookEvents()
		AddHook EmitEventHook,_EventHook,Self
		AddHook FlipHook,_FlipHook,Self
	End Method
	
	Method UnHookEvents()
		RemoveHook EmitEventHook,_EventHook,Self
		RemoveHook FlipHook,_FlipHook,Self	
	End Method

	Method OnEvent(Event:TEvent) Final
		Select event.id
			Case EVENT_KEYDOWN
				Select event.data
					Case KEY_ESCAPE
				      _Terminate=True
				    Case KEY_F1
						_ShowHelp=Not _showHelp
				    Case KEY_F2
						_ShowStats=Not _showStats				
				    Case KEY_F3
						_VSync=Not _VSync
						If _VSync 
							_VSyncText="Off"
						Else	
							_VSyncText="On"
						End If
				    Case KEY_F4
						D3D9GraphicsDriver().DoSyncGPU= Not D3D9GraphicsDriver().DoSyncGPU
						If D3D9GraphicsDriver().DoSyncGPU 
							_SyncGPUText="Off"
						Else	
							_SyncGPUText="On"
						End If
	
				    Case KEY_F10
			    	    _FullScreen= Not _FullScreen
						ConfigureDisplay()		
			    End Select
				KeyDownEvent(event.data, event.mods)
			Case EVENT_APPTERMINATE
			    _Terminate=True	
			Case EVENT_MOUSEMOVE
				_CursorX=event.X
			    _CursorY=event.Y	
				MouseMoveEvent(event.x,event.y)
	        Case EVENT_MOUSEENTER
				_cursorShow=True
			Case EVENT_MOUSELEAVE	
				_cursorShow=False	
			Case EVENT_MOUSEDOWN
				MouseDownEvent(event.data)
			Case EVENT_TIMERTICK
				If event.source= _LogicTimer Then UpdateWorld()			
		End Select
	End Method
	
		
	
	
	Method DisplayHelp()
		DrawText "[ESC] - Quit",10,20
		DrawText "[F1]  - Show/Hide Help",10,30
		DrawText "[F2]  - Show/Hide Stats",10,40		
		DrawText "[F3]  - VSync "+_VSyncText,10,50	
		DrawText "[F4]  - Sync GPU "+_SyncGPUText,10,60	
		DrawText "[F10] - Toggle Fullscreen/Window",10,70
	End Method
	
	
	
	Method Render() Final
		RenderWorld()
		' Draw Cusor
	    SetBlend(MASKBLEND)
		SetColor 255,255,255
		SetScale 1,1
		SetAlpha 1	
		If _cursorShow And _cursor Then DrawImage _cursor,_cursorX,_cursorY
		If _showHelp Then DisplayHelp()
        If _showStats Then DrawText("FPS = "+_FPS+ " MAX FPS ="+_MaxFPS,0,_DisplayHeight-30)
		Flip()
	End Method
	
	
	Method Flip()
		.Flip _VSync
	End Method
	
	Method Initialize() Final
		GetDefaultSettings(_DisplayWidth,_DisplayHeight,_DisplayDepth,_FullScreen,_LogicFPS)
		HookEvents()		
	End Method
	
	Method Finalize() Final
		UnHookEvents()
	End Method
	
	Method ConfigureDisplay() Final
	      HideMouse()
		If _FullScreen
			Graphics _DisplayWidth,_DisplayHeight,_DisplayDepth
		Else
			Graphics _DisplayWidth,_DisplayHeight,0	
		End If	
	End Method
	
	Method Run() Final  
		LoadData()
		_Terminate=False
		_LogicTimer=CreateTimer(_LogicFPS)
		While Not _Terminate
			While PeekEvent()
				PollEvent()
			Wend
			Render()
		Wend
		EndGraphics
		StopTimer(_LogicTimer)
	End Method		
	
	
	
	Method GetDefaultSettings(Width:Int Var,Height:Int Var,Depth:Int Var,FullScreen:Int Var,LogicFPS:Int Var)	
	End Method
	Method LoadData()
	End Method	
	Method UpdateWorld()	
	End Method	
	Method RenderWorld()
	  Cls
	End Method	
	Method KeyDownEvent(KeyCode:Int, Modifer:Int)	    
	End Method	
	Method MouseMoveEvent(X:Int,Y:Int)    	
	End Method	
	Method MouseDownEvent(MouseButton : Int)	
	End Method
	
End Type

Function Run(App:TMaxApplication)
	App.Initialize()
	App.ConfigureDisplay()
	App.Run()
	App.Finalize()
End Function



