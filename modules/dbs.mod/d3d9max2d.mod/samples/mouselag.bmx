Import dbs.d3d9max2d
' this is interesting demo provided to me by GFK to demonstrate input lag
' I have updated his demo to work across all drivers.
' on slow hardware all drivers for me lagged to extent.  ie. I could move the mouse significantly faster than
' then screen refresh so the dot is always behind.  This demo has serious overdraw issue which forces the issue of render lag to
' become visible.
'
' on my hardware all drivers have bit of lag due to the overdraw 
' noticable... not really lag but more frames are buffered so the mouse "floats" for lack of better term
' as far as driver behavior dx7/dx9 seem to work the OGL lags terribly.  Goal is for dx7 to work like dx9
' if i disable GPU Sync on dx9 then lag is more significant
' 
' this is however a very contrived example but is good demo of the input lag issue.
' and hopefully shows stablity of the dx7 driver in contrast to the dx9 driver


SetGraphicsDriver d3d9max2ddriver()
' uncomment to disable GPU Syncing
'D3D9GraphicsDriver().DoSyncGPU=0
' uncomment to test other drivers
'SetGraphicsDriver D3D7Max2DDriver()
'SetGraphicsDriver GLMax2DDriver()


Graphics 1024,768,0


While Not KeyDown(key_escape) And Not AppTerminate()
	Cls
        'draw some crap to take up time
	SetColor 0,0,0
	For n = 0 To 10000
	
		DrawRect Rand(800),Rand(600),Rand(100),Rand(100)
	Next
	SetColor 255,255,0
	tvirtualgraphics.set(800,600)
	DrawOval tvirtualgraphics.MouseX()-5,tvirtualgraphics.MouseY()-5,10,10

	Flip 0
Wend

Type TVirtualGraphics
	Global virtualWidth, virtualHeight
	Global xRatio!, yRatio!


	Function Set(Width = 640, Height = 480, scale:Float = 1)
		TVirtualGraphics.virtualWidth = Width
		TVirtualGraphics.virtualHeight = height
		TVirtualGraphics.xRatio! = width / Double(GraphicsWidth())
		TVirtualGraphics.yRatio! = height / Double(GraphicsHeight())
		
	?Win32
		Local D3D9Driver:TD3D9Max2DDriver = TD3D9Max2DDriver(_max2dDriver)
		Local D3D7Driver:TD3D7Max2DDriver = TD3D7Max2DDriver(_max2dDriver)
		
					
		If D3D9Driver
			Local matrix#[] = [2.0 / (width / scale#), 0.0, 0.0, 0.0,..
			 										0.0, -2.0 / (height / scale#), 0.0, 0.0,..
			 										0.0, 0.0, 1.0, 0.0,..
		 											-1 - (1.0 / width), 1 + (1.0 / height), 1.0, 1.0] ',scale#]
			
			D3D9Driver._D3DDevice9.SetTransform(D3DTS_PROJECTION, matrix)
		Else	If D3D7Driver
			Local matrix1#[] = [2.0 / width, 0.0, 0.0, 0.0,..
			 										0.0, -2.0 / height, 0.0, 0.0,..
			 										0.0, 0.0, 1.0, 0.0,..
		 											-1 - (1.0 / width), 1 + (1.0 / height), 1.0, 1.0]
			
			D3D7Driver.device.SetTransform(D3DTS_PROJECTION, matrix1)
		Else	
	? 
			glMatrixMode(GL_PROJECTION)
			glLoadIdentity()
			glortho(0, width / scale#, height / scale#, 0, -1, 1)
			glMatrixMode(GL_MODELVIEW)
			glLoadIdentity()
	?Win32
		EndIf
	?
	End Function
	
	Function MouseX()
		Return (BRL.PolledInput.MouseX() * TVirtualGraphics.xRatio!)
	End Function
	
	Function MouseY()
		Return (BRL.PolledInput.MouseY() * TVirtualGraphics.yRatio!)
	End Function
End Type