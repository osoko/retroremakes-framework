' createcanvas.bmx

Strict 
Import dbs.d3d9max2d
Import maxgui.maxgui
Import MaxGUI.Win32MaxGUIEx

SetGraphicsDriver D3D9Max2DDriver()
'SetGraphicsDriver GLMax2DDriver()


Global GAME_WIDTH=640
Global GAME_HEIGHT=240

' create a centered window with client size GAME_WIDTH,GAME_HEIGHT

Local wx=(GadgetWidth(Desktop())-GAME_WIDTH)/2
Local wy=(GadgetHeight(Desktop())-GAME_HEIGHT)/2

Local window:TGadget=CreateWindow("My Canvas",wx,wy,GAME_WIDTH,GAME_HEIGHT,Null,WINDOW_TITLEBAR|WINDOW_CLIENTCOORDS|WINDOW_RESIZABLE)

' create a canvas for our game

Local canvas:TGadget=CreateCanvas(0,0,320,240,window)
Local canvas2:TGadget=CreateCanvas(320,0,320,240,window)

' create an update timer

CreateTimer 60
Local quit:Int=False
While WaitEvent()
	Select EventID()
		Case EVENT_TIMERTICK
			RedrawGadget canvas
			RedrawGadget canvas2

		Case EVENT_GADGETPAINT
			Local g:TGraphics=CanvasGraphics(canvas)			
			SetGraphics g			
			SetOrigin 160,120
			SetLineWidth 5
			SetClsColor 255,244,0

		
			Cls
			Local t=MilliSecs()
			DrawLine 0,0,120*Cos(t),120*Sin(t)
			DrawLine 0,0,80*Cos(t/60),80*Sin(t/60)
			Flip 


			g=CanvasGraphics(canvas2)			
			SetGraphics g			
			SetOrigin 160,120
			SetLineWidth 15

			SetClsColor 255,0,0
			Cls			
			DrawLine 0,0,120*Cos(t),120*Sin(t)
			DrawLine 0,0,80*Cos(t/60),80*Sin(t/60)
			Flip 

		Case EVENT_WINDOWCLOSE
			FreeGadget canvas
			FreeGadget canvas2
			Exit
		Case EVENT_APPTERMINATE
			End
	End Select
Wend




