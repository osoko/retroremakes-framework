
Type MyRenderCanvas Extends wxGLCanvas


	Field initialized:Int

	Field previousPosition:TVector2D
	
	Field dragging:Int


	Field _w:Int, _h:Int
	
	Field _sizeChanged:Int
	
		
	'backdrop rgb values
	Field clearR:Int, clearG:Int, clearB:Int

	Method SetBGColor(r:Int, g:Int, b:Int)
		clearR = r
		clearG = g
		clearB = b
	End Method

rem
	Field drawTimer:wxTimer
	Field curFPS:Int, curTime:Int, prevTime:Int, checkTime:Int, fpscounter:Int



	'***** PRIVATE *****


	Method OnInit()
		SetBackgroundStyle(wxBG_STYLE_CUSTOM)
		drawTimer = New wxTimer.Create(Self,998)

		previousPosition = New TVector

		clearR = 50
		clearG = 50
		clearB = 50

		Connect(998,wxEVT_TIMER, OnDrawTick)
		ConnectAny(wxEVT_MOUSE_EVENTS, _OnMouse)
		ConnectAny(wxEVT_SIZE, _OnSize)
		drawTimer.Start(UPDATE_TIME)
	End Method

	Function _OnSize(Event:wxEvent)
		MyRenderCanvas(Event.parent).OnSize(Event)
	End Function

	Method OnSize(Event:wxEvent)
		wxSizeEvent(Event).GetSize(_w, _h)
		_sizeChanged=True
		Event.skip()
	End Method

	Function OnDrawTick(Event:wxEvent)
		wxWindow(Event.parent).Refresh()
	End Function

	Function _OnMouse(Event:wxEvent)
		MyRenderCanvas(Event.parent).OnMouse(Event)
	End Function

	Method OnMouse(Event:wxEvent)
		Local evt:wxMouseEvent = wxMouseEvent(Event)
		Select evt.GetEventType()
			Case wxEVT_MOTION
				Local x:Int, y:Int
				evt.GetPosition(x, y)
				EmitEvent(CreateEvent( EVENT_MOUSEMOVE, Event.parent, 0, 0, x, y))

				If dragging And GL_engineUpdateTimer.isRunning()

					Local v:TVector = New TVector
					v.Set( x, y )
					v.SubtractVector( previousPosition )
					previousPosition.set( x, y )

					For Local e:TEmitter = EachIn TEngineBase._objectList
						e.MovePosition( v )
					Next
				End If

			Case wxEVT_LEFT_DOWN
				Local x:Int, y:Int
				evt.GetPosition(x, y)
				EmitEvent(CreateEvent( EVENT_MOUSEDOWN, Event.parent, 1))
				dragging = True
				previousPosition.set(x,y)

			Case wxEVT_LEFT_UP
				EmitEvent(CreateEvent( EVENT_MOUSEUP, Event.parent, 1))
				dragging = False
			Case wxEVT_RIGHT_DOWN
				EmitEvent(CreateEvent( EVENT_MOUSEDOWN, Event.parent, 2))
			Case wxEVT_RIGHT_UP
				EmitEvent(CreateEvent( EVENT_MOUSEUP, Event.parent, 2))
			Case wxEVT_MIDDLE_DOWN
				EmitEvent(CreateEvent( EVENT_MOUSEDOWN, Event.parent, 3))
			Case wxEVT_MIDDLE_UP
				EmitEvent(CreateEvent( EVENT_MOUSEUP, Event.parent, 3))
			Case wxEVT_MOUSEWHEEL

		End Select
		Event.Skip()
	End Method

	Method OnPaint(Event:wxPaintEvent)
		SetGraphics CanvasGraphics2D( Self )
		If _sizeChanged Then
			_sizeChanged = False
			SetViewport(0, 0, _w, _h )
		End If

		Local r:Int, g:Int, b:Int
		SetClsColor clearR,clearG,clearB
		Cls
		If TEditorImage(GL_toDraw)
			Local i:TEditorImage = TEditorImage(GL_toDraw)
			i.DrawBaseImage( _w/2, _h/2 )
		End If
		ENGINE.Draw(0)

		SetRotation 0
		SetScale 1,1
		SetBlend ALPHABLEND
		SetAlpha 1
		' ++++++++++++++++
		' FPS Counter
		curTime = $7FFFFFFF & MilliSecs()
		If curTime > checkTime Or prevTime > curTime Then
			checkTime = curTime + 1000
			curFPS = fpscounter
			fpscounter = 0
		Else
			fpscounter = fpscounter + 1
		End If
		prevTime = curTime

		SetColor 0,0,0
		SetAlpha 0.5
		DrawRect(0, _h-35, _w, 35)
		SetColor 255,255,255
		SetAlpha 1
		DrawText "F5 to add selection, F6 to clear engine", 10, _h-30
		If GL_engineUpdateTimer.IsRunning()
			DrawText "F8 to stop, LMB to drag", 80,_h-15
			DrawText "FPS: "+curfps, _w-70,_h-15
			SetColor 0,255,0
			DrawText "Running", 10,_h-15
		Else
			DrawText "F8 to start", 80,_h-15
			SetColor 255,0,0
			DrawText "Stopped", 10,_h-15
		End If
		Flip

		GCCollect()

	End Method

	Method GetCenter(x:Int Var, y:Int Var)
		x = _w/2
		y = _h/2
	End Method
endrem
End Type
