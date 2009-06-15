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

 
  Dx9Utils.bmx 

  Utility Function to convert DX9 Surface to Pixmap
  
  Version history:
    V0.1 - Initial Test Version 
    V0.3 - fixed issue with not cleaning up tmp surface in ConvertToPixmap
    V0.7 - change convertion of 32 bit surfaces to not assume that X8R8G8B8 will have $FF in X8
End Rem

SuperStrict
Import pub.directx
Import brl.pixmap

Function CreateOffscreenPlainSurface:IDirect3DSurface9(D3DDevice9 :IDirect3DDevice9, Width:Int,Height:Int,Format:Int=D3DFMT_X8R8G8B8)
	Local result:IDirect3DSurface9
	If  D3DDevice9.CreateOffscreenPlainSurface(Width,Height,Format,D3DPOOL_DEFAULT, result,Null)<> D3D_OK
		Return Null
	Else
		Return result	
	End If	
End Function

Function ConvertToPixmap:TPixmap(D3DDevice9 :IDirect3DDevice9, Source:IDirect3DSurface9)
	If Not source Return Null
	Local pixmap: TPixmap
	Local sourceDesc: D3DSURFACE_DESC= New D3DSURFACE_DESC
	source.GetDesc(sourceDesc)	
	Local pixmapSurface:IDirect3DSurface9
	pixmapSurface=CreateOffScreenPlainSurface(D3DDevice9, sourceDesc.Width,sourceDesc.Height)
	If Not pixmapSurface Return Null

	
	
	Select sourceDesc.Format
		Case D3DFMT_X8R8G8B8,D3DFMT_A8R8G8B8
			Local lockrect:D3DLOCKED_RECT=New D3DLOCKED_RECT
			If  Source.LockRect(lockrect,Null,0)=D3D_OK					
				Local sp:TPixmap=TPixmap.CreateStatic(lockrect.pBits,sourceDesc.Width,sourceDesc.Height,lockrect.Pitch,PF_BGRA8888)
				If sourceDesc.Format =	D3DFMT_X8R8G8B8
					pixmap= ConvertPixmap(sp,PF_BGR888)
				Else	
					pixmap=CopyPixmap(sp)								
				End If	
				Source.UnlockRect()		
			End If		
		Case D3DFMT_R5G6B5
			Local srcLockrect:D3DLOCKED_RECT=New D3DLOCKED_RECT
			If  Source.LockRect(srcLockrect,Null,0)=D3D_OK
				Local destLockRect:D3DLOCKED_RECT=New D3DLOCKED_RECT
				If  pixmapSurface.LockRect(destLockrect,Null,0)=D3D_OK
					For Local y:Int=0 Until sourceDesc.Height
				    	Local srcBits:Short Ptr= Short Ptr(srcLockrect.pBits+srcLockrect.Pitch*y)
						Local destBits:Int Ptr=Int Ptr(destLockRect.pBits+destLockRect.Pitch*y)
						For Local x:Int= 0 Until sourceDesc.Width
							Local color:Short = srcBits[0]							
							destBits[0]=$FF000000 | ((((color Shr 11)& $1F) Shl 19)) | (((color Shr 5)& $3F) Shl 11) | ((color& $1F) Shl 3)
							srcBits:+1
							destBits:+1	
						Next 
					Next						
					Local sp:TPixmap=TPixmap.CreateStatic(destLockrect.pBits,sourceDesc.Width,sourceDesc.Height,destLockrect.Pitch,PF_BGRA8888)
					pixmap=CopyPixmap(sp)	
					pixmapSurface.UnlockRect()					
				End If
				Source.UnlockRect()
			End If
		Case D3DFMT_A1R5G5B5	
			Local srcLockrect:D3DLOCKED_RECT=New D3DLOCKED_RECT
			If  Source.LockRect(srcLockrect,Null,0)=D3D_OK
				Local destLockRect:D3DLOCKED_RECT=New D3DLOCKED_RECT
				If  pixmapSurface.LockRect(destLockrect,Null,0)=D3D_OK
					For Local y:Int=0 Until sourceDesc.Height
				    	Local srcBits:Short Ptr= Short Ptr(srcLockrect.pBits+srcLockrect.Pitch*y)
						Local destBits:Int Ptr=Int Ptr(destLockRect.pBits+destLockRect.Pitch*y)
						For Local x:Int= 0 Until sourceDesc.Width
							Local color:Short = srcBits[0]							
							destBits[0]= (((color Shr 15)&$01)Shl 31) | (((color Shr 10)&$1F)Shl 19) | (((color Shr 5)&$1F)Shl 11) |  (color&$1F)Shl 3
							srcBits:+1
							destBits:+1	
						Next 
					Next					
					Local sp:TPixmap=TPixmap.CreateStatic(destLockrect.pBits,sourceDesc.Width,sourceDesc.Height,destLockrect.Pitch,PF_BGRA8888)
					pixmap=CopyPixmap(sp)	
					pixmapSurface.UnlockRect()					
				End If
				Source.UnlockRect()			
			End If
		
	End Select	
	pixmapSurface.Release_							
	Return pixmap		
End Function

