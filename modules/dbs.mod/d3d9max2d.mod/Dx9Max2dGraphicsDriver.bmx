Rem

	Copyright (c) 2007, 2008, Douglas Stastny

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.



  Dx9Max2dGraphicsDriver

  This unit implements D3D9Max2DDriver for BlitzMax  

  Version history:
    V0.6 - revised to single Vertex Buffer
    V0.5 - revised Driver Message Sink to detach upon DestroyMessage since implies context nonlonger valid
    V0.4 - updated to new version of Dx9GraphicsDriver
	V0.3 - changed to BRL 1.24 Max2d implementation
    V0.2 - changed textures mangement to use DEVICECREATE/DESTROY Message improve tab or display changes
    V0.2 - revised handling of Pixmap to Texture, no longer converts texture to format lets the Pixmap.Paste handle
    V0.1 - Initial Test Version 

End Rem

SuperStrict
Import dbs.dx9graphics
Import BRL.Max2d
Import "DX9Utils.bmx"


Type TDx9DeviceTexture
	Field _Driver: TD3D9Max2DDriver
	Field _texture:IDirect3DTexture9
	Field _textureWidth : Int
	Field _textureHeight: Int
	Field _textureFormat: Int	
	Field _Pixmap       : TPixmap
	Field _Flags : Int
	
	Field	_Vertices:Float[24] ' 6 floats per vert 4 verts per QUAD
	

	Method SendMessage:Object( message:Object,sender:Object )
		Local Msg:TDirect3DDevice9Message= TDirect3DDevice9Message(message)
		If Msg
			Select Msg.Message 			
				Case TDirect3DDevice9Status.CREATED
					OnDeviceCreate()	
				Case TDirect3DDevice9Status.RESET					
					OnDeviceReset()			
				Case TDirect3DDevice9Status.LOST
					OnDeviceLost()
				Case TDirect3DDevice9Status.DESTROYED
					OnDeviceDestroy()			
			End Select		
		End If
	End Method
	
				
	Method OnDeviceLost()
	End Method
	
	Method OnDeviceReset()
	End Method
	
	Method OnDeviceDestroy()
		If Not _Texture Return
'		If _Driver._ActiveTexture=_texture _Driver.UpdateRenderState()
		If _Texture	
		  _Texture.Release_()
		End If
		_Texture = Null
'		dxlog "Texture  destroyed"+Self.ToString()
		_driver._DXDriver.DeleteDeviceObject(Self)
	End Method
	
	Method OnDeviceCreate()
		'dxlog "Texture created"+Self.ToString()
		Local usage:Int=0
		Local level:Int=1
		If (_Flags&MIPMAPPEDIMAGE) 
			usage=D3DUSAGE_AUTOGENMIPMAP
			level=0
		End If	
		Local hr:Int= _Driver._DXDriver.Direct3DDevice9().CreateTexture(_TextureWidth,_TextureHeight,level,usage,_TextureFormat,D3DPOOL_MANAGED,_Texture,Null)
'		Local hr:Int= _Driver._DXDriver.Direct3DDevice9().CreateTexture(_TextureWidth,_TextureHeight,level,usage,_TextureFormat,D3DPOOL_DEFAULT,_Texture,Null)
		If hr<>D3D_OK Then Throw "Failed to Create Texture:"+HR
		' lock the surface
		Local lockrect:D3DLOCKED_RECT=New D3DLOCKED_RECT
		If  _Texture.LockRect(0,lockrect,Null,0)<> D3D_OK
			_Texture.Release_
			_Texture=Null
			Throw "Failed to Lock Texture"
		End If		
		' Move the pixmap to offscreen surface
		Local sp:TPixmap=TPixmap.CreateStatic(lockrect.pBits,_TextureWidth,_TextureHeight,lockrect.Pitch,PF_BGRA8888)
        sp.Paste(_Pixmap,0,0)
		' unlock the surface
		_Texture.UnlockRect(0)
		' Texture ready		
	End Method
	
	
	Method SetUV(u0#,v0#,u1#,v1#)
		_Vertices[4]=u0
		_Vertices[5]=v0
		_Vertices[10]=u1
		_Vertices[11]=v0
		_Vertices[16]=u0
		_Vertices[17]=v1
		_Vertices[22]=u1
		_Vertices[23]=v1
		
	End Method


	Function Create:TDx9DeviceTexture(Driver: TD3D9Max2DDriver, pixmap:TPixmap,flags:Int)				
		Function Pow2Size:Int( n:Int )
			Local t:Int=1
			While t<n
				t:*2
			Wend
			Return t
		End Function
		
		Local this:TDx9DeviceTexture= New TDx9DeviceTexture
		this._Driver=Driver
		this._Pixmap=pixmap
		this._textureFormat=D3DFMT_A8R8G8B8		
		this._Flags=flags
		this._textureWidth =Pow2Size(this._Pixmap.Width)
		this._textureHeight=Pow2Size(this._Pixmap.height)	 
		this.SetUV 0.0,0.0,Float(this._Pixmap.Width)/this._textureWidth,Float(this._Pixmap.Height)/this._textureHeight
		this._Driver._DXDriver.AddDeviceObject(this)	
		Return this												
	End Function
	
	Method Dispose()
	    'dxlog "Texture disposed"+Self.ToString()
		_Driver._DXDriver.DeleteDeviceObject(Self)	
	End Method	
End Type


Type TDX9ImageFrame Extends TImageFrame
	Field _Dx9DeviceTexture : TDx9DeviceTexture		
	
	Method Delete()
		_Dx9DeviceTexture.Dispose()
		_Dx9DeviceTexture=Null	
	End Method

	Method SetUV(u0#,v0#,u1#,v1#)
		_Dx9DeviceTexture.SetUV(u0#,v0#,u1#,v1#)		
	End Method

	Method Draw( x0#,y0#,x1#,y1#,tx#,ty# )
		_Dx9DeviceTexture._driver.DrawFrame Self,x0#,y0#,x1#,y1#,tx#,ty#
	End Method
	

	Function Create:TDX9ImageFrame(Driver:TD3D9Max2DDriver, pixmap:TPixmap,flags:Int)	
		Local this:TDX9ImageFrame= New TDX9ImageFrame
		this._Dx9DeviceTexture= TDx9DeviceTexture.Create(Driver,pixmap,flags)		
		Return this												
	End Function	
End Type



Type TVertexRender
	Field _VertexSize:Int

	Field _FVF : Int

	Field _D3D9Max2DDriver  : TD3D9Max2DDriver 
	Field _D3DDevice9 :IDirect3DDevice9
	
	Field _Texture:IDirect3DTexture9
	Field _TextureFlags:Int=0
	
	Function Create:TVertexRender(FVF:Int,VertexSize:Int)
		Local vb:TVertexRender= New TVertexRender
		vb._VertexSize= VertexSize
		vb._FVF        = FVF
		vb.OnDeviceLost()
		Return vb	
	End Function
	
	Method OnDeviceLost()
	  	_Texture=Null
		_TextureFlags=Null
		_D3DDevice9=Null
		_D3D9Max2DDriver=Null
	End Method
	
	
	Method OnDeviceReset(D3D9Max2DDriver  : TD3D9Max2DDriver)
		_D3D9Max2DDriver  = D3D9Max2DDriver
		_D3DDevice9 = D3D9Max2DDriver._D3DDevice9		

	End Method

   Method DrawPrimitive(PrimativeType:Int, PrimativeCount:Int,VertexCount:Int, Vertices:Byte Ptr  ,Texture:IDirect3DTexture9=Null,TextureFlags:Int=0)
		If Not _D3DDevice9	Return
		If Texture<>_Texture
			_D3DDevice9.SetTexture 0,Texture			
			If Texture
				' if not already in texturing set default states	 	    				
				If _Texture=Null				
					_D3DDevice9.SetTextureStageState 0,D3DTSS_COLOROP,D3DTOP_MODULATE
					_D3DDevice9.SetTextureStageState 0,D3DTSS_ALPHAOP,D3DTOP_MODULATE
  				EndIf				
				' If the filter mode has changed update RenderStates
				If _TextureFlags<>(TextureFlags& FILTEREDIMAGE)
					_TextureFlags=(TextureFlags& FILTEREDIMAGE)
					If _TextureFlags					
						_D3DDevice9.SetSamplerState 0,D3DSAMP_MAGFILTER,D3DTEXF_LINEAR
						_D3DDevice9.SetSamplerState 0,D3DSAMP_MINFILTER,D3DTEXF_LINEAR
						_D3DDevice9.SetSamplerState 0,D3DSAMP_MIPFILTER,D3DTEXF_LINEAR
					Else					
						_D3DDevice9.SetSamplerState 0,D3DSAMP_MAGFILTER,D3DTEXF_POINT
						_D3DDevice9.SetSamplerState 0,D3DSAMP_MINFILTER,D3DTEXF_POINT
						_D3DDevice9.SetSamplerState 0,D3DSAMP_MIPFILTER,D3DTEXF_POINT									
					EndIf
				EndIf				
				
			Else
			  ' we are switching back to solid primatives			
			  _D3DDevice9.SetTextureStageState 0,D3DTSS_COLOROP,D3DTOP_DISABLE
			  _D3DDevice9.SetTextureStageState 0,D3DTSS_ALPHAOP,D3DTOP_DISABLE
			EndIf
			_Texture=Texture
		End If	
		_D3DDevice9.SetFVF(_FVF) 			
		_D3DDevice9.DrawPrimitiveUP(PrimativeType,PrimativeCount,Vertices,_VertexSize)
   End Method
End Type


Type TD3D9Max2DDriver Extends TMax2DDriver 
	Field _DXDriver: TD3D9GraphicsDriver

   Const TEXTVERTEXSIZE:Int=24

	Const TEXTUREDFVF :Int= D3DFVF_XYZ |D3DFVF_DIFFUSE|D3DFVF_TEX1
	

	Const VERTX:Int =0
	Const VERTY:Int =1
	Const VERTZ:Int =2

	Const VERTD:Int =3
	Const VERTU:Int =4
	Const VERTV:Int =5



	   
	Field _D3DDevice9 :IDirect3DDevice9
	Field _IsInScene : Int
	


	
	Field _PixmapSurface:IDirect3DSurface9
	Field _PixmapSurfaceWidth : Int
	Field _PixmapSurfaceHeight: Int
			

	

	Field _Drawcolor	:Int
	Field _Clscolor		:Int
	Field _ix			:Float
	Field _iy			:Float
	Field _jx			:Float
	Field _jy			:Float
	Field _Linewidth	:Float
	Field _ActiveBlend	:Int
	Field _ClipRect		:TRect
	Field _viewport:D3DVIEWPORT9


	Field _BlendStateBlocks: IDirect3DStateBlock9[6]
	

	Field _Renderer: TVertexRender
	Field	_Vertices:Float[24] ' 6 floats per vert 4 verts per QUAD
	Field	_VerticesColor: Int Ptr ' used for color access
	
   Method New()
		_VerticesColor= Int Ptr(Varptr _Vertices[0])
		_DXDriver = D3D9GraphicsDriver()
		If Not _DXDriver Throw "DirectX 9 not supported"
		_viewport= New D3DVIEWPORT9
		_Viewport.MinZ=0.0
		_Viewport.MaxZ=1.0
	 
		_Renderer= TVertexRender.Create(TEXTUREDFVF,TEXTVERTEXSIZE)

	End Method
	
	Method Delete()
	End Method


	
	Method SendMessage:Object( message:Object,sender:Object )
		Local Msg:TDirect3DDevice9Message= TDirect3DDevice9Message(message)
		If Msg
			Select Msg.Message
				Case TDirect3DDevice9Status.CREATED
					OnDeviceCreate()	
				Case TDirect3DDevice9Status.RESET					
					OnDeviceReset()			
				Case TDirect3DDevice9Status.LOST
					OnDeviceLost()
				Case TDirect3DDevice9Status.DESTROYED
					OnDeviceDestroy()					
			End Select		
		End If
	End Method

	Method OnDeviceCreate()
		'dxlog "OnDeviceCreate2d Driver"
		_D3DDevice9= _DXDriver.Direct3DDevice9()
	End Method
			
	Method OnDeviceLost()
		'dxlog "OnDeviceLost 2d Driver"
		For Local i:Int=MASKBLEND To SHADEBLEND
			If _BlendStateBlocks[i]
				_BlendStateBlocks[i].Release_
				_BlendStateBlocks[i]=Null
			End If	
		Next
		If _PixmapSurface
			_PixmapSurface.Release_
			_PixmapSurface=Null
		End If
	
		
		_Renderer.OnDeviceLost()
	End Method	

	Method OnDeviceDestroy()
		_D3DDevice9=Null	
		_DXDriver.DeleteDeviceObject(Self)	
		'dxlog "OnDeviceDestroy 2d Driver"
	End Method
	
	Method OnDeviceReset()
		'dxlog "OnDeviceReset 2d Driver"
		_Renderer.OnDeviceReset(Self)
		
	
		' recreate pixmap cache if we have one		
		If (_PixmapSurfaceWidth >0) And (_PixmapSurfaceHeight>0)
			Local dwFormat : Int=D3DFMT_X8R8G8B8			
			_D3DDevice9.CreateOffscreenPlainSurface(_PixmapSurfaceWidth,_PixmapSurfaceHeight,dwFormat,D3DPOOL_DEFAULT, _PixmapSurface,Null)
		End If		

		' setup 2d projection matrix
		Local depth : Int = 2
		Local width:Int =GraphicsWidth()
		Local height:Int =GraphicsHeight()
		
		_Viewport.X=0
		_Viewport.Y=0
		_Viewport.Width=width
		_Viewport.Height=height
		_D3DDevice9.SetViewport(_Viewport)
		
		_ClipRect = TRect.Create(0,0,width,height)
		Local matrix#[]=[..
			2.0/width,0.0,0.0,0.0,..
			 0.0,-2.0/height,0.0,0.0,..
			 0.0,0.0,2.0/depth,0.0,..
			 -1-(1.0/width),1+(1.0/height),1.0,1.0]				
		_D3DDevice9.SetTransform(D3DTS_PROJECTION,matrix)	
		_D3DDevice9.SetRenderState D3DRS_ALPHAREF,$80
		_D3DDevice9.SetRenderState D3DRS_ALPHAFUNC,D3DCMP_GREATEREQUAL 
		_D3DDevice9.SetRenderState D3DRS_ALPHATESTENABLE,False
		_D3DDevice9.SetRenderState D3DRS_ALPHABLENDENABLE,False			
		_D3DDevice9.SetRenderState D3DRS_LIGHTING,False
		_D3DDevice9.SetRenderState D3DRS_CULLMODE,D3DCULL_NONE	

		_D3DDevice9.SetTextureStageState(0,D3DTSS_COLOROP,D3DTOP_DISABLE)
		
		_D3DDevice9.SetTextureStageState(0,D3DTSS_COLORARG1,D3DTA_TEXTURE)		
		
		_D3DDevice9.SetTextureStageState(0,D3DTSS_COLORARG2,D3DTA_DIFFUSE)		
		
		_D3DDevice9.SetTextureStageState(0,D3DTSS_ALPHAOP,D3DTOP_DISABLE)
		
		_D3DDevice9.SetTextureStageState(0,D3DTSS_ALPHAARG1,D3DTA_TEXTURE)
		
		_D3DDevice9.SetTextureStageState(0,D3DTSS_ALPHAARG2,D3DTA_DIFFUSE)
		
		
		_D3DDevice9.SetTextureStageState 0,D3DTSS_COLOROP,D3DTOP_MODULATE
		_D3DDevice9.SetTextureStageState 0,D3DTSS_ALPHAOP,D3DTOP_MODULATE
		
		_D3DDevice9.SetSamplerState 0, D3DSAMP_ADDRESSU,D3DTADDRESS_CLAMP	
		_D3DDevice9.SetSamplerState 0, D3DSAMP_ADDRESSV,D3DTADDRESS_CLAMP	
		

				
		_D3DDevice9.SetSamplerState 0,D3DSAMP_MAGFILTER,D3DTEXF_POINT
		_D3DDevice9.SetSamplerState 0,D3DSAMP_MINFILTER,D3DTEXF_POINT
		_D3DDevice9.SetSamplerState 0,D3DSAMP_MIPFILTER,D3DTEXF_POINT
		

	
		_D3DDevice9.BeginStateBlock()
		_D3DDevice9.SetRenderState D3DRS_ALPHATESTENABLE,True
		_D3DDevice9.SetRenderState D3DRS_ALPHABLENDENABLE,False				
		_D3DDevice9.EndStateBlock(_BlendStateBlocks[MASKBLEND])
		
		_D3DDevice9.BeginStateBlock()		
		_D3DDevice9.SetRenderState D3DRS_ALPHATESTENABLE,False
		_D3DDevice9.SetRenderState D3DRS_ALPHABLENDENABLE,False		
		_D3DDevice9.EndStateBlock(_BlendStateBlocks[SOLIDBLEND])
		
		_D3DDevice9.BeginStateBlock()
		_D3DDevice9.SetRenderState D3DRS_ALPHATESTENABLE,False
		_D3DDevice9.SetRenderState D3DRS_ALPHABLENDENABLE,True
		_D3DDevice9.SetRenderState D3DRS_SRCBLEND,D3DBLEND_SRCALPHA
		_D3DDevice9.SetRenderState D3DRS_DESTBLEND,D3DBLEND_INVSRCALPHA			
		_D3DDevice9.EndStateBlock(_BlendStateBlocks[ALPHABLEND])
		
		
		_D3DDevice9.BeginStateBlock()
		_D3DDevice9.SetRenderState D3DRS_ALPHATESTENABLE,False
		_D3DDevice9.SetRenderState D3DRS_ALPHABLENDENABLE,True
		_D3DDevice9.SetRenderState D3DRS_SRCBLEND,D3DBLEND_SRCALPHA
		_D3DDevice9.SetRenderState D3DRS_DESTBLEND,D3DBLEND_ONE				
		_D3DDevice9.EndStateBlock(_BlendStateBlocks[LIGHTBLEND])		
		_D3DDevice9.BeginStateBlock()
		_D3DDevice9.SetRenderState D3DRS_ALPHATESTENABLE,False
		_D3DDevice9.SetRenderState D3DRS_ALPHABLENDENABLE,True
		_D3DDevice9.SetRenderState D3DRS_SRCBLEND,D3DBLEND_ZERO
		_D3DDevice9.SetRenderState D3DRS_DESTBLEND,D3DBLEND_SRCCOLOR			
		_D3DDevice9.EndStateBlock(_BlendStateBlocks[SHADEBLEND])			
		_BlendStateBlocks[SOLIDBLEND].Apply()
		_ActiveBlend=SOLIDBLEND		
		If TMax2DGraphics.Current()		
			TMax2DGraphics.Current().Validate	
		End If	
		'dxlog "init"
		_DxDriver.BeginScene()
		'dxlog "init"		
	End Method

	
	
	' TGraphicsDriver methods
	
	Method GraphicsModes:TGraphicsMode[]() 
		Return _DXDriver.GraphicsModes()
	End Method
	
	Method AttachGraphics:TGraphics( widget:Int,flags:Int )
		Local g:TD3D9Graphics =_DXDriver.AttachGraphics( widget,flags )
		If g 
			_DXDriver.AddDeviceObject(Self)	
			Return TMax2DGraphics.Create( g,Self )
		End If	
	End Method
	Method CreateGraphics:TGraphics( width:Int,height:Int,depth:Int,hertz:Int,flags:Int ) 
		Local g:TD3D9Graphics=_DXDriver.CreateGraphics( width,height,depth,hertz,flags )
		If g 
			_DXDriver.AddDeviceObject(Self)	
			Return TMax2DGraphics.Create( g,Self )
		End If	
	End Method
	Method SetGraphics( g:TGraphics ) 
		If Not g
			_DXDriver.SetGraphics(Null)
			TMax2DGraphics.ClearCurrent			
			Return
		EndIf
		' Get The DX Graphics object and reflect to driver	
		Local max2dGraphic:TMax2DGraphics=TMax2DGraphics(g)
		_DXDriver.SetGraphics(max2dGraphic._graphics)
		max2dGraphic.MakeCurrent
		max2dGraphic.Validate												
	End Method
	
	

	Method Flip( sync:Int ) 
	'	UpdateRenderState() 
		_DXDriver.EndScene()		
		_DXDriver.Flip(sync)
		_DXDriver.BeginScene()		
	End Method	
	
	' TMax2dDriverMethods
	Method CreateFrameFromPixmap:TImageFrame( pixmap:TPixmap,flags:Int ) 
		Return TDX9ImageFrame.Create(Self, pixmap,flags)
	End Method
	
	Method SetBlend( blend:Int )
		If blend=_ActiveBlend Return
		If _BlendStateBlocks[blend] _BlendStateBlocks[blend].Apply()
		_ActiveBlend=blend	
	End Method

	Method SetAlpha( alpha:Float )
		_Drawcolor=(Int(255*Max(Min(alpha,1),0)) Shl 24)|(_Drawcolor&$ffffff)
	End Method

	Method SetColor( red:Int,green:Int,blue:Int )
		red=Max(Min(red,255),0)
		green=Max(Min(green,255),0)
		blue=Max(Min(blue,255),0)
		_Drawcolor=(_Drawcolor&$ff000000)|(red Shl 16)|(green Shl 8)|blue	
		' Set drawing verts colors
		_VerticesColor[VERTD]=_DrawColor
		_VerticesColor[VERTD+6]=_DrawColor
		_VerticesColor[VERTD+12]=_DrawColor
		_VerticesColor[VERTD+18]=_DrawColor
	End Method
		
	Method SetClsColor( red:Int,green:Int,blue:Int)
		red=Max(Min(red,255),0)
		green=Max(Min(green,255),0)
		blue=Max(Min(blue,255),0)
		_Clscolor=$ff000000|(red Shl 16)|(green Shl 8)|blue
	End Method

	Method SetViewport( x:Int,y:Int,width:Int,height:Int )		
		_ClipRect = TRect.Create(x,y,x+width,y+height)
		If _D3DDevice9
			If x=0 And y=0 And width=GraphicsWidth() And height=GraphicsHeight()
				_D3DDevice9.SetRenderState D3DRS_CLIPPLANEENABLE,0
			Else
				_D3DDevice9.SetClipPlane 0,[1.0,0.0,0.0,-Float(x)]
				_D3DDevice9.SetClipPlane 1,[-1.0,0.0,0.0,Float(x+width)]
				_D3DDevice9.SetClipPlane 2,[0.0,1.0,0.0,-Float(y)]
				_D3DDevice9.SetClipPlane 3,[0.0,-1.0,0.0,Float(y+height)]
				_D3DDevice9.SetRenderState D3DRS_CLIPPLANEENABLE,15
			EndIf
		End If
	End Method

	Method SetTransform( xx:Float,xy:Float,yx:Float,yy:Float)
		_ix=xx
		_iy=xy
		_jx=yx
		_jy=yy		
	End Method

	Method SetLineWidth( width:Float)
		_Linewidth=width
	End Method
	
	Method Cls() 
		If _D3DDevice9
			If  _D3DDevice9.Clear(1,_ClipRect,D3DCLEAR_TARGET,_ClsColor,1.0,0)	<> 0 Throw "Clear Failed"
		EndIf 	
	End Method
	
	Method Plot( x:Float,y:Float) 
		_Vertices[VERTX]=x+.5001
		_Vertices[VERTY]=y+.5001
		_Renderer.DrawPrimitive(D3DPT_POINTLIST,1,1,_Vertices)
	End Method	
	
	
	Method DrawLine( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float )	
		Local lx0#,ly0#,lx1#,ly1#			
		lx0=x0*_ix+y0*_iy+tx
		ly0=x0*_jx+y0*_jy+ty
		lx1=x1*_ix+y1*_iy+tx
		ly1=x1*_jx+y1*_jy+ty
	
		If _Linewidth=1.0	
				_Vertices[VERTX]=lx0+.5001
				_Vertices[VERTY]=ly0+.5001
				_Vertices[VERTX+6]=lx1+.5001
				_Vertices[VERTY+6]=ly1+.5001
				_Renderer.DrawPrimitive(D3DPT_LINELIST,1,2,_Vertices)
		Else'D3DPT_TRIANGLESTRIP
				Local lw#=_Linewidth*0.5
				If Abs(ly1-ly0)>Abs(lx1-lx0)
					_Vertices[VERTX]=lx0-lw
					_Vertices[VERTY]=ly0			
					_Vertices[VERTX+6]=lx0+lw
					_Vertices[VERTY+6]=ly0								
					_Vertices[VERTX+12]=lx1-lw
					_Vertices[VERTY+12]=ly1									
					_Vertices[VERTX+18]=lx1+lw
					_Vertices[VERTY+18]=ly1
				Else
					_Vertices[VERTX]=lx0
					_Vertices[VERTY]=ly0-lw
					_Vertices[VERTX+6]=lx0
					_Vertices[VERTY+6]=ly0+lw
					_Vertices[VERTX+12]=lx1
					_Vertices[VERTY+12]=ly1-lw
					_Vertices[VERTX+18]=lx1
					_Vertices[VERTY+18]=ly1+lw
				EndIf
				_Renderer.DrawPrimitive(D3DPT_TRIANGLESTRIP,2,4,_Vertices)
		EndIf	 
	End Method	
	
	Method DrawRect( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float )
			_Vertices[VERTX]=x0*_ix+y0*_iy+tx
			_Vertices[VERTY]=x0*_jx+y0*_jy+ty
			
			_Vertices[VERTX+6]=x1*_ix+y0*_iy+tx
			_Vertices[VERTY+6]=x1*_jx+y0*_jy+ty
					
			_Vertices[VERTX+12]=x0*_ix+y1*_iy+tx
			_Vertices[VERTY+12]=x0*_jx+y1*_jy+ty
					
			_Vertices[VERTX+18]=x1*_ix+y1*_iy+tx
			_Vertices[VERTY+18]=x1*_jx+y1*_jy+ty
			_Renderer.DrawPrimitive(D3DPT_TRIANGLESTRIP,2,4,_Vertices)
	End Method
	Method DrawOval( x0:Float,y0:Float,x1:Float,y1:Float,tx:Float,ty:Float )

		Local xr#=(x1-x0)*.5
		Local yr#=(y1-y0)*.5		
		Local segs:Int=Abs(xr)+Abs(yr)		
		segs=Max(segs,12)&~3
		Local vrts:Float[]=New Float[(segs+1)*6]	
		x0:+xr
		y0:+yr		
    	Local p: Float Ptr= vrts
		For Local i:Int=0 To segs
			Local th#=-i*360#/segs
			Local x#=x0+Cos(th)*xr
			Local y#=y0-Sin(th)*yr
			Local offset:Int = i*6
			p[VERTX+offset]=x*_ix+y*_iy+tx
			p[VERTY+offset]=x*_jx+y*_jy+ty	
		'	p[VERTZ+offset]=0
			Int Ptr(p)[VERTD+offset]=_DrawColor
		Next	
		_Renderer.DrawPrimitive(D3DPT_TRIANGLEFAN,segs,segs+1,p)	
		
	End Method	
	
	Method DrawPoly( xy:Float[],handlex:Float,handley:Float,originx:Float,originy:Float ) 

		If xy.length<6 Or (xy.length&1) Return
		Local vertices:Int=xy.length/2
		Local vrts:Float[]=New Float[vertices*6]	
		' Lock the vertex buffer.
    	Local p: Float Ptr=vrts
			Local vi:Int = 0
			For Local i:Int=0 Until Len xy Step 2
				Local x#=xy[i+0]+handlex
				Local y#=xy[i+1]+handley
				p[vi+VERTX]=x*_ix+y*_iy+originx
				p[vi+VERTY]=x*_jx+y*_jy+originy
				Int Ptr(p)[vi+VERTD]=_DrawColor
				vi:+6
			Next	
			_Renderer.DrawPrimitive(D3DPT_TRIANGLEFAN,(vertices-3)+1,vertices,p)			
	End Method
	Method DrawPixmap( pixmap:TPixmap,x:Int,y:Int ) 
		If Not _D3DDevice9 Return 'Not UpdateRenderState() Return
		If Not pixmap Return
		' need to clip our rects
		Local srcRect:TRect=TRect.Create(0,0,pixmap.width,pixmap.height)
		Local destRect:TRect=New TRect
		OffsetRect(srcrect,x,y)
		' dont draw not visible								
'		If IntersectRect(destRect,srcRect,_Dx9GraphicsDevice._ScreenRect)=0 Return 
		If IntersectRect(destRect,srcRect,_ClipRect)=0 Return 
		' calcuate the srcRect
		srcRect._Left=destRect._Left-x
		srcRect._Top =destRect._Top-y
		srcRect._Right=srcRect._Left+destRect.Width()
		srcRect._Bottom=srcRect._Top+destRect.Height()
			
		' need to have in format we can deal with so we pick a 32bit format	
		' since thats all pixmaps can really do
		If pixmap.format<>PF_BGRA8888 pixmap=pixmap.convert(PF_BGRA8888)
		' create off screen surface if one doesnt exist or existing one is too small
		If (_PixmapSurface=Null) Or (Pixmap.Width>_PixmapSurfaceWidth) Or (Pixmap.Height>_PixmapSurfaceHeight)	
			If _PixmapSurface
				_PixmapSurface.Release_
				_PixmapSurface =Null
			End If	
			_PixmapSurfaceWidth = Pixmap.Width
			_PixmapSurfaceHeight= Pixmap.Height	
			Local dwFormat : Int=D3DFMT_X8R8G8B8			
			' create a surface
			If _D3DDevice9.CreateOffscreenPlainSurface(_PixmapSurfaceWidth,_PixmapSurfaceHeight,dwFormat,D3DPOOL_DEFAULT , _PixmapSurface,Null) <> DD_OK 
				Return
			End If	
		End If
		' lock the surface
		Local lockrect:D3DLOCKED_RECT=New D3DLOCKED_RECT
		If  _PixmapSurface.LockRect(lockrect,Null,0)<> DD_OK
			_PixmapSurface.Release_
			_PixmapSurface=Null
			Return
		End If		
		' Move the pixmap to offscreen surface
		Local sp:TPixmap=TPixmap.CreateStatic(lockrect.pBits,pixmap.Width,pixmap.Height,lockrect.Pitch,pixmap.Format)
        sp.Paste(pixmap,0,0)
		' unlock the surface
		_PixmapSurface.UnlockRect()		
		' Since we are in a scene need to end it to draw pixmaps		
		_D3DDevice9.EndScene()
		' get our render target
		Local target:IDirect3DSurface9
		If _D3DDevice9.GetRenderTarget(0,target)=DD_Ok		
			' copy our offscreen surface to the render target
			_D3DDevice9.StretchRect(_PixmapSurface,srcRect,target,destRect,D3DTEXF_POINT)
			' release the target we are done
			target.Release_
		End If		
		' restart the scene
		_D3DDevice9.BeginScene()				
	
	End Method
	Method GrabPixmap:TPixmap( x:Int,y:Int,width:Int,height:Int ) 
		Local pixmap : TPixmap= CreatePixmap(width,height,PF_BGRA8888)
		Local offscreenSurface :IDirect3DSurface9
 
		If _D3DDevice9 'UpdateRenderState()
			_D3DDevice9.EndScene()
			' get our render target
			Local target:IDirect3DSurface9
			If _D3DDevice9.GetRenderTarget(0,target)=D3D_Ok		
			' copy our render target to offscreen surface
			' create a surface
				Local desc: D3DSURFACE_DESC= New D3DSURFACE_DESC
				target.GetDesc(desc)	
				If _D3DDevice9.CreateOffscreenPlainSurface(desc.Width,desc.Height,desc.Format,D3DPOOL_SYSTEMMEM , offscreenSurface ,Null) = D3D_OK 											
					If _D3DDevice9.GetRenderTargetData(target,offscreenSurface) = D3D_OK
					  pixmap=ConvertToPixMap(_D3DDevice9,offscreenSurface)
					  If pixmap pixmap= pixmap.Window(x,y,width,height).Copy() 				
					End If
					offscreenSurface.Release_ 									
				End If
			' release the target we are done
				target.Release_
			End If																				
			' restart the scene
			_D3DDevice9.BeginScene()				
		End If		
		Return pixmap
	End Method
	
	Method DrawFrame( frame:TDX9ImageFrame,x0#,y0#,x1#,y1#,tx#,ty#)
		Local deviceTexture : TDx9DeviceTexture=frame._Dx9DeviceTexture
		Local p: Float Ptr= Varptr(deviceTexture._Vertices[0])
		Local d: Int Ptr = Int Ptr (p)
		p[0]=x0*_ix+y0*_iy+tx
		p[1]=x0*_jx+y0*_jy+ty
		d[3]=_DrawColor 
		
		p[6]=x1*_ix+y0*_iy+tx
		p[7]=x1*_jx+y0*_jy+ty
		d[9]=_DrawColor 

				
		p[12]=x0*_ix+y1*_iy+tx
		p[13]=x0*_jx+y1*_jy+ty
		d[15]=_DrawColor


				
		p[18]=x1*_ix+y1*_iy+tx
		p[19]=x1*_jx+y1*_jy+ty
		d[21]=_DrawColor
		_Renderer.DrawPrimitive(D3DPT_TRIANGLESTRIP,2,4,p,deviceTexture._Texture,deviceTexture._Flags)
	End Method	
End Type	

Rem
bbdoc: Get Dx9 Max2D Driver
about:
The returned driver can be used with #brl.graphics.SetGraphicsDriver to enable Direct3D Max2D rendering.
End Rem
Function D3D9Max2DDriver:TD3D9Max2DDriver()
	If D3D9GraphicsDriver()
		Global _driver:TD3D9Max2DDriver=New TD3D9Max2DDriver
		Return _driver
	EndIf
End Function


	






