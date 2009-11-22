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



  This unit implements DX9GraphicsDriver for BlitzMax
  
  Version history:
    V0.6 - added flag to try to fix lag and force the GPU to sync before the present
	   - added code center window based graphics
	
    V0.5 - added Cap checking and ablitlty to get caps for current display adapter
    V0.4 - complete rewrite,  better match to brl 1.24 Dx7 driver model to access raw interfaces
         - usage of swapchains for multiple render targets when using MAXGUI
	V0.4 - used swapchain to flip to control VSYNC without reseting devivce
	V0.4 - updated to 1.24 fixed issue with order of imports resolving
	V0.3 - fixed issue deletion queue not always purging deleted objects until shutdown
	V0.2 - revised DeleteDevice Object to Queue objects for deletion. Fixes issue with
	       Garbage collection deleting objects while cycling foreach of activeobjects
    V0.2 - fixed issue with _InScene when D3DDevice Recreated
    V0.1 - Initial Test Version 


End Rem

SuperStrict
Import pub.directx
Import brl.Graphics
Import brl.linkedlist
Import pub.win32
Import pub.directx
Import "d3d9caps.bmx"
'Import "d3d9.bmx"

Extern "Win32"
	Function GetParent:Int(hWnd:Int)
	Function IntersectRect(lprcDst: Byte Ptr, lprcSrc1:Byte Ptr,lprcSrc2: Byte Ptr)
	Function OffsetRect:Int(lprc: Byte Ptr, dx:Int, dy: Int)
	Function OutputDebugStringA(txt:Byte Ptr)

End Extern



Global _DX9GRAPHICSEXWINDOWCLASS:Byte Ptr="DX9WinClass".ToCString()
Global _dx9driver : TD3D9GraphicsDriver


rem
Function DXLog( t$ )
	?Debug
	WriteStdout t+"~n"
	Local b: Byte Ptr = t.ToCString()
	OutputDebugStringA(b)
	MemFree b
	?	
End Function
endrem

Type TRect
	Field _Left	:Int
	Field _Top	: Int
	Field _Right : Int
	Field _Bottom: Int
	
	Function Create:TRect(ALeft:Int,ATop:Int,ARight:Int,ABottom:Int)
		Local this:TRect=New TRect
		this._Left=ALeft
		this._Top=ATop
		this._Right=ARight		
		this._Bottom=ABottom
		Return this
	End Function
	Method Width:Int()
		Return _Right-_Left
	End Method
	Method Height:Int()
		Return _Bottom-_Top
	End Method
End Type

Type TDirect3DDevice9Status
	Const DESTROYED:Int=0
	Const CREATED  :Int=1	
	Const RESET    :Int=2
	Const LOST     :Int=3
End Type

Type TDirect3DDevice9Message
  	Field Message: Int

	Function Create:TDirect3DDevice9Message(Message:Int)
		Local this:TDirect3DDevice9Message= New TDirect3DDevice9Message
		this.Message=Message
		Return this
	End Function
End Type



Global DIRECT3DDEVICE9RESETMSG : TDirect3DDevice9Message=TDirect3DDevice9Message.Create(TDirect3DDevice9Status.RESET)   
Global DIRECT3DDEVICE9LOSTMSG : TDirect3DDevice9Message=TDirect3DDevice9Message.Create(TDirect3DDevice9Status.LOST)   
Global DIRECT3DDEVICE9CREATEDTMSG : TDirect3DDevice9Message=TDirect3DDevice9Message.Create(TDirect3DDevice9Status.CREATED)   
Global DIRECT3DDEVICE9DESTROYEDMSG: TDirect3DDevice9Message=TDirect3DDevice9Message.Create(TDirect3DDevice9Status.DESTROYED)   




Function FindMode:TGraphicsMode( width:Int,height:Int,depth:Int,hertz:Int,modes:TGraphicsMode[] )
	Local mode:TGraphicsMode
	Local md :Int=$7fff
	For Local t:TGraphicsMode=EachIn modes
		If width=t.width And height=t.height And depth=t.depth
			Local d:Int=Abs(hertz-t.hertz)
			If d<md
				md=d
				mode=t
			EndIf
		EndIf
	Next
	Return mode
End Function

Function BestMode:TGraphicsMode( width:Int,height:Int,depth:Int,hertz:Int,modes:TGraphicsMode[] )
	Local mode:TGraphicsMode
	mode=FindMode( width,height,depth,hertz,modes )
	If mode Return mode
	mode=FindMode( width,height,32,hertz,modes )
	If mode Return mode
	mode=FindMode( width,height,24,hertz,modes )
	If mode Return mode
	mode=FindMode( width,height,16,hertz,modes )
	If mode Return mode
End Function



Function WndProc:Int( hwnd:Int,message:Int,wp:Int,lp:Int ) "win32"
	bbSystemEmitOSEvent hwnd,message,wp,lp,Null
	Select message
	Case WM_CLOSE
		Return 0
	Case WM_SYSKEYDOWN
		If wp<>KEY_F4 Return 0
	' ensure the valid Flag is current due to mode/focus changes	
	Case WM_SETFOCUS		
		_dx9driver.ValidateGraphics
	' ensure the valid Flag is current due to mode/focus changes		
	Case WM_KILLFOCUS
		_dx9driver.ValidateGraphics
	End Select
	Return DefWindowProcA( hwnd,message,wp,lp )
End Function


Type TD3D9Graphics Extends TGraphics
	Field _flags:Int
	Field _SwapChain:IDirect3DSwapChain9
	Field _RenderTarget : IDirect3DSurface9  
	

	Field _PresentParams: D3DPRESENT_PARAMETERS = New D3DPRESENT_PARAMETERS 	
	Field _RasterStatus : D3DRASTER_STATUS = New D3DRASTER_STATUS
	Field _CompletionQuery : IDirect3DQuery9
	Field _SyncIssued  : Int= False 	
	

	Method Driver:TGraphicsDriver()
		Return _dx9driver
	End Method

	Method GetSettings( width:Int Var,height:Int Var,depth:Int Var,hertz:Int Var,flags:Int Var )
		ValidateSize
		width=_PresentParams.BackBufferWidth
		height=_PresentParams.BackBufferHeight
		Select _PresentParams.BackBufferFormat
			Case D3DFMT_R5G6B5
		   		depth = 16;
		   		hertz = _PresentParams.FullScreen_RefreshRateInHz
 			Case D3DFMT_X8R8G8B8
		   		depth = 32
		   		hertz = _PresentParams.FullScreen_RefreshRateInHz
			Default			
				depth=0
				hertz=0
		End Select		
		flags=_flags
	End Method

	Method Close()
		If Not _PresentParams.hDeviceWindow Return		
		_dx9driver.CloseGraphics( Self )
		DestroyWindow _PresentParams.hDeviceWindow
		_PresentParams.hDeviceWindow=Null
	End Method
	
	Method Flip( sync:Int )
		Const S_FALSE:Int = 1
		If _SwapChain	
			If _SyncIssued And _CompletionQuery 
				' Empty the command buffer And wait Until the GPU is idle.	
				While(_CompletionQuery.GetData(Null, 0, D3DGETDATA_FLUSH )=S_FALSE)
				Wend								
				_SyncIssued =False
			End If				
			Local flags: Int=0			
			If sync
			  ' Wait for VBLank or error in call			
			  Local hr :Int = 0
			  Repeat
			    hr=_SwapChain.GetRasterStatus(_RasterStatus)
			  Until _RasterStatus.InVBlank Or hr
			End If
			SyncGPU()	
			'SyncGPU2()		
		      _SwapChain.Present(Null,Null,Null,Null,flags)
	
			Rem
			If sync
			  ' Wait for VBLank or error in call			
			  Local hr :Int = 0
			  Repeat
			    hr=_SwapChain.GetRasterStatus(_RasterStatus)
			  Until Not _RasterStatus.InVBlank Or hr
			End If	
		   	End Rem
		End If
	End Method
	

	Method SyncGPU()
		If (_CompletionQuery And _dx9driver.DoSyncGPU) 
			_CompletionQuery.Issue(D3DISSUE_END)
			_SyncIssued =True
		End If
	End Method

Rem
	Field _Lockrect: D3DLOCKED_RECT = New D3DLOCKED_RECT
	Method SyncGPU2()
	Return
		If _dx9driver.DoSyncGPU
			If _Rendertarget.LockRect(_Lockrect,Null,D3DLOCK_NOSYSLOCK)=D3D_OK
				_Rendertarget.UnlockRect()
			Else
				DXLog "failed to lock texture"		
			End If
		End If
		Return 	
	End Method
End Rem	
	Function Attach:TD3D9Graphics( hwnd:Int,flags:Int )
		Local rect:	TRect =New TRect
        GetClientRect hwnd,Int Ptr Byte Ptr rect
		Return New TD3D9Graphics._Create(hwnd,rect.width(),rect.height(),0,0,flags)
	End Function
	
	Function Create:TD3D9Graphics( width:Int,height:Int,depth:Int,hertz:Int,flags:Int )
		Global _reg : Int
		If Not _reg : Int
			Local wc:WNDCLASS=New WNDCLASS
			wc.hInstance=GetModuleHandleA(Null)
			wc.lpfnWndProc=WndProc
			wc.hCursor=LoadCursorA( Null,Byte Ptr IDC_ARROW )
			wc.lpszClassName=_DX9GRAPHICSEXWINDOWCLASS
			RegisterClassA( wc )
			_reg=True
		EndIf

		Local hinst:Int=GetModuleHandleA(Null)
		Local title:Byte Ptr=AppTitle.ToCString()
	
		Local hwnd:Int
		If depth
			hwnd=CreateWindowExA( 0,_DX9GRAPHICSEXWINDOWCLASS,title,WS_VISIBLE|WS_POPUP,0,0,width,height,0,0,hinst,Null )
		Else
			Local style:Int=WS_VISIBLE|WS_CAPTION|WS_SYSMENU' |WS_SIZEBOX 
			Local rect :TRect = TRect.Create(32,32,width+32,height+32)
			Local desktopHWND:Int=GetDesktopWindow()
			Local desktopRect:TRect =  New TRect
			GetWindowRect( desktopHWND,Int Ptr Byte Ptr desktopRect)
			
			rect._Left=desktopRect.Width()/2-width/2
			rect._Top=desktopRect.Height()/2-height/2		
			rect._Right=rect._Left+width
			rect._Bottom=rect._Top+height							
			
			AdjustWindowRect Int Ptr Byte Ptr rect,style,0
			width=rect.Width()
			height=rect.Height()
			hwnd=CreateWindowExA( 0,_DX9GRAPHICSEXWINDOWCLASS,title,style,rect._Left,rect._Top,width,height,0,0,hinst,Null )
		EndIf

		MemFree title

		If Not hwnd Return Null

		Return New TD3D9Graphics._Create(hwnd ,width,height,depth,hertz,flags)
	End Function
	
	Method _Create:TD3D9Graphics(hwnd :Int, width:Int,height:Int,depth:Int,hertz:Int,flags:Int)	
	    'DXLog "TD3D9Graphics._Create"    
		_flags=flags
		_PresentParams.BackBufferWidth	= width
		_PresentParams.BackBufferHeight	= height		
		Select depth
			Case 16
				_PresentParams.BackBufferFormat	= D3DFMT_R5G6B5
				_PresentParams.FullScreen_RefreshRateInHz=hertz
			Case 32
				_PresentParams.BackBufferFormat	= D3DFMT_X8R8G8B8
				_PresentParams.FullScreen_RefreshRateInHz=hertz				
			Default	
				_PresentParams.BackBufferFormat=D3DFMT_UNKNOWN
				_PresentParams.FullScreen_RefreshRateInHz=0
		End Select		
		_PresentParams.BackBufferCount=1
		_PresentParams.MultiSampleType=D3DMULTISAMPLE_NONE
		_PresentParams.SwapEffect= D3DSWAPEFFECT_FLIP'  D3DSWAPEFFECT_DISCARD'D3DSWAPEFFECT_FLIP'D3DSWAPEFFECT_DISCARD
		_PresentParams.hDeviceWindow=hwnd 
		_PresentParams.Windowed=depth=0
		If Not(_flags&GRAPHICS_BACKBUFFER) 
			'DXLog "GRAPHICS_BACKBUFFER flag required"
			Return Null
		End If	
		If (_flags&GRAPHICS_ALPHABUFFER)
			'DXLog "GRAPHICS_ALPHABUFFER flag not supported"
			Return Null
		End If	
		If (_flags&GRAPHICS_ACCUMBUFFER)
			'DXLog "GRAPHICS_ACCUMBUFFER flag not supported"
			Return Null
		End If		
		If _flags & GRAPHICS_DEPTHBUFFER
			DebugLog "CREATING DEPTH BUFFER"
			_PresentParams.EnableAutoDepthStencil=True ' true if we want z-buffer
			_PresentParams.AutoDepthStencilFormat=D3DFMT_D16			
		End If	
		If _flags & GRAPHICS_STENCILBUFFER
			DebugLog "CREATING STENCIL BUFFER"		
			_PresentParams.EnableAutoDepthStencil=True ' true if we want z-buffer
			_PresentParams.AutoDepthStencilFormat=D3DFMT_D24S8			
		End If	
		_PresentParams.PresentationInterval=D3DPRESENT_INTERVAL_IMMEDIATE
		'_PresentParams.Flags=D3DPRESENTFLAG_LOCKABLE_BACKBUFFER ' note this is bad bad bad		
		Return Self
		'pp.PresentationInterval=D3DPRESENT_INTERVAL_DEFAULT

	End Method
	
	Method ValidateSize()
		Local rect:TRect=New TRect
		GetClientRect _PresentParams.hDeviceWindow,Int Ptr Byte Ptr rect
		Local width : Int =rect.Width()
		Local height: Int =rect.Height()
		If width<=0 Or height<=0 Return
		If width=_PresentParams.BackBufferWidth And height=_PresentParams.BackBufferHeight Return
		' Reset SwapChain
		_PresentParams.BackBufferWidth	= width
		_PresentParams.BackBufferHeight	= height			
		If _dx9driver._Direct3DDevice9
			' destroy the swapchain
			DestroySwapChain()			
			' if FocusedHWND=graphics hwnd reset device
			If _dx9driver._FocusHWND=_PresentParams.hDeviceWindow
				If Not _dx9driver.ResetDevice()
				  'DXLog "TD3D9Graphics.ValidateSize - Resize Failed" 
				End If
			End If
		End If
	End Method
	
	Method RenderTarget: IDirect3DSurface9 ()
		ValidateSize
		Return _RenderTarget
	End Method
	
	Method CreateSwapChain:Int()
		'DXLog "TD3D9Graphics.CreateSwapChain "+Self.ToString()
		Local d3ddev9 : IDirect3DDevice9=_dx9driver._Direct3DDevice9
		If Not d3ddev9  Return False
		If _dx9driver._FocusHWND=_PresentParams.hDeviceWindow Then
			' get default swap chain
			If d3ddev9.GetSwapChain(0,_SwapChain)
				'DXLog "failed GetSwapChain"
	 			Return False
			End If		
		Else
			' create additional swap chain on device
			If d3ddev9.CreateAdditionalSwapChain(_PresentParams,_SwapChain)
				'DXLog "failed CreateAdditionalSwapChain"
				Return False
			End If
		End If
		If _SwapChain.GetBackBuffer(0,0,_RenderTarget) 
			'DXLog "failed GetBackBuffer"
			DestroySwapChain()
			Return False		
		End If	
		' create the completion query
		_CompletionQuery = Null
		_SyncIssued = False
		If d3ddev9.CreateQuery(D3DQUERYTYPE_EVENT, _CompletionQuery)
			'DXLog "failed To Completion Query"		 	
		End If				
		Return True
	End Method

	Method DestroySwapChain()
		If Not _SwapChain Return
		'DXLog "TD3D9Graphics.DestroySwapChain"+Self.ToString()
		'If _CompletionQuery DXLog "_CompletionQuery.Release ="+_CompletionQuery.Release_()	
		If _CompletionQuery _CompletionQuery.Release_()
		'If _RenderTarget DXLog "_RenderTarget.Release ="+_RenderTarget.Release_()
		If _RenderTarget _RenderTarget.Release_()
		'If _SwapChain DXLog "_SwapChain.Release ="+_SwapChain.Release_()
		If _SwapChain _SwapChain.Release_()
		_CompletionQuery= Null
		_RenderTarget=Null
		_SwapChain =Null
	End Method
	
	
End Type

Type TD3D9GraphicsDriver Extends TGraphicsDriver
     	Global DoSyncGPU            	: Int = 1
	Global IsValid 			: Int
	
	Field _FocusHWND    		: Int
	Field _OwnHWND      		: Int
	Field _FocusPresentParams	: D3DPRESENT_PARAMETERS = New D3DPRESENT_PARAMETERS 
	Field _modes				: TGraphicsMode[]
	Field _Direct3D9 			: IDirect3D9
	Field _Direct3DDevice9		: IDirect3DDevice9	
	Field _graphics				: TD3D9Graphics
	Field _inScene      		: Int	
	Field _graphicss			: TList=New TList	
	Field _DeviceObjects : TList = New TList
	Field _DeleteObjectList : TList = New TList
	Field _IsInScene    : Int=False
	Field _IsDeviceLost : Int=True
	Field _Caps : D3DCAPS9= Null
	Field _AdapterInfo : D3DADAPTER_IDENTIFIER9=Null


	
	
	Method AddDeviceObject(item:Object)
		If _DeviceObjects.Contains(item) Return
		_DeviceObjects.AddLast(item)
		If _Direct3DDevice9 item.SendMessage(DIRECT3DDEVICE9CREATEDTMSG ,Self) Else Return			
		If Not _IsDeviceLost item.SendMessage(DIRECT3DDEVICE9RESETMSG,Self)
	End Method
	
	Method DeleteDeviceObject(item:Object)
		If _DeviceObjects.Contains(item)
			If Not _DeleteObjectList.Contains(item)
				_DeleteObjectList.AddFirst(item)
			End If				
		End If
	End Method
	
	Method ReleaseDeviceObjects()
		For Local item:Object=EachIn  _DeleteObjectList
			_DeviceObjects.Remove(item)	
			If _Direct3DDevice9	
				If Not _IsDeviceLost item.SendMessage(DIRECT3DDEVICE9LOSTMSG ,Self)
				item.SendMessage(DIRECT3DDEVICE9DESTROYEDMSG,Self)
			EndIf
		Next
		_DeleteObjectList.Clear()
	End Method
	Method NotifyAllDeviceObjects(Msg: TDirect3DDevice9Message)
		ReleaseDeviceObjects()	
		For Local item:Object= EachIn _DeviceObjects 
			item.SendMessage(Msg,Self)
		Next
		ReleaseDeviceObjects()
	End Method		

	Method GraphicsModes:TGraphicsMode[]()
		Return _modes		
	End Method
	
	Method _AddGraphic:TD3D9Graphics(g:TD3D9Graphics)
		If Not g Return Null
		' get focusHWND
		Local hwnd:Int=g._PresentParams.hDeviceWindow
		If Not _graphicss.Count()
			Local Current:Int=hwnd
			Repeat
				_FocusHWND=Current
				Current=GetParent(_FocusHWND)
			Until Current=Null	
			' if there FocsusHWND=device window is owned by the graphics
			_OwnHWND =g._PresentParams.hDeviceWindow=_FocusHWND								
		End If	
		' add to list of graphicss		
		_graphicss.AddLast g		
		Return g
	End Method
	
	Method AttachGraphics:TD3D9Graphics( hwnd:Int,flags:Int )
		' if we own an HWND we can not attach any
		If _OwnHWND Return Null
		Return _AddGraphic(TD3D9Graphics.Attach( hwnd,flags ))			
	End Method
		
	Method CreateGraphics:TD3D9Graphics( width:Int,height:Int,depth:Int,hertz:Int,flags:Int )
		' if we own an HWND we can create any til that is destroyed
		If _OwnHWND  Return Null
		' can have another graphics active
		If _graphicss.Count() Return Null		
		If depth 		
			Local mode:TGraphicsMode=BestMode( width,height,depth,hertz,_modes )
			If Not mode Return Null
			depth=mode.depth
			hertz=mode.hertz
		EndIf
		Return _AddGraphic(TD3D9Graphics.Create( width,height,depth,hertz,flags ))		
	End Method
	

	Method CloseGraphics( g:TD3D9Graphics )
		If Not g Return
		g.DestroySwapChain()
		_graphicss.Remove g
		If g=_graphics 
			_graphics=Null
			IsValid=False
		EndIf
		' still have active graphics objects
		If _graphicss.Count() Return		
		' destroy device no more graphics objects active
		_DestroyDirect3DDevice9
	End Method

	Method SetGraphics( g:TGraphics )
		If g=_graphics Return
		_graphics=TD3D9Graphics( g )
		ValidateGraphics
	End Method
	
	Method Graphics:TD3D9Graphics()
		Return _graphics
	End Method
	
	Method Flip( sync:Int )
		If IsValid _graphics.Flip sync
		ValidateGraphics
	End Method
	
	Method FocusHWND:Int()
	 	Return _FocusHWND
	End Method
	
	Method Caps:D3DCAPS9()
		Return _Caps
	End Method
	
	Method AdapterInfo:D3DADAPTER_IDENTIFIER9()
		Return _AdapterInfo
	End Method

	Method Direct3D9:IDirect3D9()
		Return _Direct3D9	
	End Method
	
	
	Method Direct3DDevice9:IDirect3DDevice9()
		Return _Direct3DDevice9
	End Method
	
	Method BeginScene()
		_inScene=True
		If _Direct3DDevice9 _Direct3DDevice9.BeginScene
	End Method
	
	Method EndScene()
		If _Direct3DDevice9 _Direct3DDevice9.EndScene
		_inScene=False
	End Method
	
	Method _SetActiveSwapChain:Int(g: TD3D9Graphics)
		Local renderTarget: IDirect3DSurface9  = g.RenderTarget()
		If Not renderTarget
			If Not g.CreateSwapChain() Return False
		End If
		_Direct3DDevice9.SetRenderTarget(0,g.RenderTarget())
		IsValid=True		
		Return True
	End Method
	
	Method DeviceLost()	
		If Not _IsDeviceLost Then
			_IsDeviceLost=True
			NotifyAllDeviceObjects(DIRECT3DDEVICE9LOSTMSG)
		End If
		For Local g:TD3D9Graphics=EachIn _graphicss
			g.DestroySwapChain()
		Next
	End Method
	
	Method ResetDevice:Int()
		DeviceLost()
		Select _Direct3DDevice9.Reset(_FocusPresentParams) 
		Case D3D_OK 
			'DXLog "Reset D3D_OK "
			If _IsDeviceLost Then
		   		_IsDeviceLost=False
		   		NotifyAllDeviceObjects(DIRECT3DDEVICE9RESETMSG)
			End If			
			Return True
		Case D3DERR_DEVICELOST
			'DXLog "Reset D3DERR_DEVICELOST"
	    Case D3DERR_DRIVERINTERNALERROR	
			'DXLog "Reset D3DERR_DRIVERINTERNALERROR"
		Case D3DERR_INVALIDCALL
			'DXLog "Reset D3DERR_INVALIDCALL"
		Case D3DERR_OUTOFVIDEOMEMORY
			'DXLog "Reset D3DERR_OUTOFVIDEOMEMORY"
		Default
			'DXLog "Reset Unhandled error on Reset"														
		End Select			
    	Return False		
	End Method
	
	
	Method _ValidateGraphics:Int()
		If Not _graphics Return False
		If Not _Direct3DDevice9
			If Not _CreateDirect3DDevice9(_graphics) Return False
		End If
		Select _Direct3DDevice9.TestCooperativeLevel()
		Case D3D_OK
			Return _SetActiveSwapChain(_graphics)
		Case D3DERR_DEVICELOST 
	    	DeviceLost()
			Return False
		Case D3DERR_DEVICENOTRESET			
			Return Not ResetDevice()
		Default
			'DXLog "Reset Unhandled error on TestCooperativeLevel"		
			Return False
		End Select		
	End Method
	
	Method ValidateGraphics:Int()
		Global _busy:Int
		If _busy Return IsValid
		_busy=True
		ReleaseDeviceObjects()
		Local valid:Int=_ValidateGraphics()
	
		
		If valid<>IsValid
			If valid And _inScene _Direct3DDevice9.BeginScene()
		EndIf
		
		IsValid=valid
		
		_busy=False
		Return IsValid
	End Method

	Function Create:TD3D9GraphicsDriver()
		If _dx9driver Return _dx9driver	
		If Not Direct3DCreate9 Return Null
		Local d3d9: IDirect3D9=Direct3DCreate9( $900 )
		If Not d3d9 Return Null 
		' can create a d3d9 interface so we can create the driver
		_dx9driver=New TD3D9GraphicsDriver			
		If Not _dx9driver Return Null	
		' Get Adapter Info and Caps

		_dx9driver._AdapterInfo = New  D3DADAPTER_IDENTIFIER9		
		If d3d9.GetAdapterIdentifier(0,$00000002,_dx9driver._AdapterInfo)
			'DxLog "Unable to Get AdapterInfo"	
			_dx9driver._AdapterInfo=Null
		End If
		_dx9driver._Caps= New  D3DCAPS9
		If d3d9.GetDeviceCaps(0,D3DDEVTYPE.D3DDEVTYPE_HAL,_dx9driver._Caps)
			'DxLog "Unable to read Caps"
			_dx9driver._Caps=Null
		End If


		' Build list of valid display modes			
		Local displaymodes : TList= New TList
		Local CheckFormats :Int[]=[D3DFMT_X8R8G8B8,D3DFMT_X1R5G5B5,D3DFMT_R5G6B5,D3DFMT_A2R10G10B10]
		For Local format:Int= EachIn CheckFormats
			Local c:Int=  d3d9.GetAdapterModeCount(0, format)
            For Local mode:Int = 0 Until c
                Local displayMode : D3DDISPLAYMODE=New D3DDISPLAYMODE
                d3d9 .EnumAdapterModes(0, format, mode, displayMode)				
                If( displayMode.Width < 640) Or (displayMode.Height < 480) Continue
				displaymodes.AddLast(displaymode)
			Next
		Next
		' we are done with this temporary d3d9 interface
		d3d9.Release_()
		d3d9=Null		
		' convert the d3d driver list to BMAX Display mode list array		
		_dx9driver._modes = New TGraphicsMode[displaymodes.Count()]
		Local i :Int		
		For Local dm : D3DDISPLAYMODE = EachIn displaymodes
			_dx9driver._modes[i]= New TGraphicsMode
			_dx9driver._modes[i].Width  = dm.Width 
			_dx9driver._modes[i].Height	= dm.Height
			If (dm.Format=D3DFMT_X1R5G5B5) Or (dm.Format= D3DFMT_R5G6B5)
				_dx9driver._modes[i].Depth	= 16
			Else
				_dx9driver._modes[i].Depth	= 32
			End If					
			_dx9driver._modes[i].Hertz	= dm.Refresh
			i:+1
		Next
		'DXLog "TD3D9GraphicsDriver.Create "+_dx9driver.ToString()
		Return _dx9driver
	End Function
	
	Method _CreateDirect3DDevice9:TD3D9GraphicsDriver(g:TD3D9Graphics)	
		'DXLog "TD3D9GraphicsDriver._CreateDirect3DDevice9 "+Self.ToString()		
		GraphicsSeq:+1
		If Not GraphicsSeq GraphicsSeq=1
		_Direct3D9=Direct3DCreate9( $900 )
		If Not _Direct3D9 Return Null 
		' build present params for focusHWND
		' start by copying graphics present params
		MemCopy	_FocusPresentParams,g._PresentParams,SizeOf(_FocusPresentParams)
		If _FocusHWND<>g._PresentParams.hDeviceWindow
			' windowed mode so setup dummy Swapchain on primary device to handle resets
			_FocusPresentParams.BackBufferWidth	= 1
			_FocusPresentParams.BackBufferHeight	= 1
			_FocusPresentParams.hDeviceWindow=_FocusHWND
		End If
		' try to create different devices
		' falling back to full software vertex processing if necessary
		If _Direct3D9.CreateDevice( 0,D3DDEVTYPE_HAL,_FocusHWND,D3DCREATE_PUREDEVICE|D3DCREATE_HARDWARE_VERTEXPROCESSING|D3DCREATE_FPU_PRESERVE,_FocusPresentParams,_Direct3DDevice9)<>D3D_OK
			If _Direct3D9.CreateDevice( 0,D3DDEVTYPE_HAL,_FocusHWND,D3DCREATE_HARDWARE_VERTEXPROCESSING|D3DCREATE_FPU_PRESERVE,_FocusPresentParams,_Direct3DDevice9)<>D3D_OK
				If _Direct3D9.CreateDevice( 0,D3DDEVTYPE_HAL,_FocusHWND,D3DCREATE_SOFTWARE_VERTEXPROCESSING|D3DCREATE_FPU_PRESERVE,_FocusPresentParams,_Direct3DDevice9)<>D3D_OK			
				    'DXLog "failed To create device _D3dDev9"
					_DestroyDirect3DDevice9()
					Return Null
				End If
			End If		
		EndIf	
		

		
		
		' Notify all dependent objects
		NotifyAllDeviceObjects(DIRECT3DDEVICE9CREATEDTMSG)
		NotifyAllDeviceObjects(DIRECT3DDEVICE9RESETMSG)	
		_IsDeviceLost=False			
		Return Self
	End Method
	
	Method _DestroyDirect3DDevice9:TD3D9GraphicsDriver()
		'DXLog "TD3D9GraphicsDriver._DestroyDirect3DDevice9 "+Self.ToString()	
		GraphicsSeq:+1
		If Not GraphicsSeq GraphicsSeq=1
		DeviceLost()			
		If _Direct3DDevice9 
			NotifyAllDeviceObjects(DIRECT3DDEVICE9DESTROYEDMSG)			
			'DXLog "_Direct3DDevice9.Release ="+_Direct3DDevice9.Release_()	
		End If	
		'If _Direct3D9 DXLog "_Direct3D9.Release="+_Direct3D9.Release_()
		If _Direct3D9 Then _Direct3D9.Release_()
		_Direct3DDevice9=Null
		_Direct3D9 = Null
		_OwnHWND=Null
		Return Null
	End Method
	

End Type


Function D3D9GraphicsDriver:TD3D9GraphicsDriver()
	Return TD3D9GraphicsDriver.Create()
End Function


