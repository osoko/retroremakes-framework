' Simple DX9 demo by Doug Stastny (dstastny@comcast.net)
'Framework brl.max2d
SuperStrict
Import brl.basic
Import brl.pngloader
' import the DX9 Driver and set it as our default
Import dbs.d3d9max2d
' import base Application Object
Import "Maxapplication.bmx"
' this only effects dx9 driver can be toggled by framework default is on
' D3D9GraphicsDriver().DoSyncGPU=1
SetGraphicsDriver D3D9Max2DDriver()
'SetGraphicsDriver D3D7Max2DDriver()
'SetGraphicsDriver GLMax2DDriver()
' uncomment framework to use/test other drivers


' particle code logic from 
' Fireworks by simonh (si@si-design.co.uk)
' customized to use a Freelist to manage number of particles and custom
' linked list to manage active particles.  Hugely faster than TList

Type TParticle
	Global _FreeList:TParticle
	Global _FreeCount:Int
	Global _ActiveList:TParticle
	Global _ActiveCount:Int

	
	Field x#,y#,z#,vy#,xd#,yd#,zd#,r#,g#,b#,alpha#
	Field _Image : TImage
	Field _Next:TParticle
	Field _Prev:TParticle
	
	
	Function Create:TParticle()
		Local p:TParticle	
		If _FreeList 
			p= _FreeList
			_FreeList=p._Next 
			_FreeCount:-1
		Else
			p= New TParticle					
		End If
		p._Next=_ActiveList
		If _ActiveList _ActiveList._Prev=p
		_ActiveList=p
		_ActiveCount:+1
		Return p
	End Function
	
	Method Dispose()
		_ActiveCount:-1
		_FreeCount:+1
		' remove from active list
		If Self=_ActiveList
			_ActiveList._Prev=Null
			_ActiveList=_ActiveList._Next			
		Else
		  _Prev._Next=_Next
	      If _Next Then _Next._Prev=_Prev
		End If
		' re initialize and add to freelist
		x#=0.0
		y#=0.0
		z#=0.0
		vy#=0.0
		xd#=0.0
		yd#=0.0
		zd#=0.0
		r#=0.0
		g#=0.0
		b#=0.0
		alpha#=0.0
		_Image=Null		
		_Next=_FreeList
		_Prev=Null
		_FreeList=Self
	End Method	
	
	' this function used to initialize the Particle Pool
	Function IntializeFreeList(DefaultSize:Int=2600)
		_FreeList=Null
		_FreeCount=0
		_ActiveList=Null
		_ActiveCount=0		
		For Local i:Int=0 Until DefaultSize
			TParticle.Create()
		Next
		While _ActiveList
			_ActiveList.Dispose()
		Wend	
	End Function
	
	
	Function Update()
		Local p:TParticle= TParticle._ActiveList
		While p
			Local sp:TParticle=p
			p=p._Next
			sp.alpha=sp.alpha-0.01
			If sp.alpha>0
				sp.x=sp.x+sp.xd*10.0
				sp.y=sp.y+sp.yd*10.0
				sp.z=sp.z+sp.zd*10.0
				sp.y=sp.y+sp.vy#
				sp.vy=sp.vy+0.02	
			Else
				sp.Dispose()
			EndIf		
		Wend	
	End Function
	
	Function Render()
		SetBlend LIGHTBLEND
		'SetBlend ALPHABLEND
		Local p:TParticle= TParticle._ActiveList
		While p			
			SetColor p.r#,p.g#,p.b#
			SetAlpha p.alpha
			SetScale 20/p.z,20/p.z	
			DrawImage p._Image,p.x,p.y				
			p=p._Next				
		Wend		
	End Function
	
	
	Function CreateFirework(Image:TImage,posX:Float,posY:Float)
		Const PARTICLESPERFIREWORK :Int=200
		Local x#=posX
		Local y#=posY


		Local z#=Rnd!(300)+100

		Local r#=Rand(255)
		Local g#=Rand(255)
		Local b#=Rand(255)

		For Local i:Int=1 To PARTICLESPERFIREWORK

			Local speed# = 0.1
			Local ang1# = Rnd!(360)
			Local ang2# = Rnd!(360)

			Local sp:TParticle=TParticle.Create()

			sp.x=x#
			sp.y=y#
			sp.z=z#

			sp.xd=Cos(ang1#)*Cos(ang2#)*speed#
			sp.yd=Cos(ang1#)*Sin(ang2#)*speed#
			sp.zd=Sin(ang1#)*speed#
	
			sp.r=r
			sp.g=g
			sp.b=b
	
			sp.alpha=1
			sp._Image=Image
	

		Next
	End Function
	
	


End Type

' override simple application framework

Type TDx9Demo Extends TMaxApplication
	Field _Starfield : TImage
	Field _Particle: TImage
	
	Const MEDIAPATH:String = "media\"
    ' helper function to load images
	Method LoadGraphic:TImage(FileName:String,flags:Int=-1)
		Local image:TImage=LoadImage(MEDIAPATH+FileName,flags)
		If image=Null Throw "Unable to Load File:"+FileName
		Return image
	End Method
    ' override any default settings	
	Method GetDefaultSettings(Width:Int Var,Height:Int Var,Depth:Int Var,FullScreen:Int Var,LogicFPS:Int Var)	
		'FullScreen=True	
	End Method
	
	Method LoadData()
		SetClsColor 0,0,255
		Cls		
		DrawText "Loading Data...",0,0
		Flip() ' <-- this is framework flip
		Delay(1000)
		TParticle.IntializeFreeList()
	 	_Starfield=LoadGraphic("starfield.png",0)
		SetMaskColor(0,0,0)
		_Cursor= LoadGraphic("cursor.png")
		SetImageHandle _cursor,ImageWidth(_cursor)/2,ImageHeight(_cursor)/2
		_Particle= LoadGraphic("spark.png")					
	End Method
	' this is updated by the LOGICFPS timer
	Method UpdateWorld()
		TParticle.Update()		
	End Method
	' render method is updated as fast as possible by framework	
	Method RenderWorld()
		'Cls <- this is slow on all platforms and unnecessary if we floodfill 
		'with background image with Solid Blend
		' Erase Background
		SetBlend SOLIDBLEND
  	 	TileImage _Starfield 	
		' Draw all TParticles
		TParticle.Render()
		' Draw our Text
        SetBlend(MASKBLEND)
		SetColor 255,255,255
		SetScale 1,1
		SetAlpha 1
        If _ShowStats 
			DrawText("Active = "+TParticle._ActiveCount+ " Free ="+TParticle._FreeCount,0,_DisplayHeight-20)				 			
	    End If	
		' framework handles the flip
	End Method
	' override the mousedown event to create a firework
	Method MouseDownEvent(MouseButton : Int)
		If MouseButton = 1 Then TParticle.CreateFirework(_Particle,_CursorX,_CursorY)		
	End Method
	
	
End Type

' Main
AppTitle="Max2d Dx9 Demo Application"
Run(New TDx9Demo)
'Run(New TDx9Demo)






