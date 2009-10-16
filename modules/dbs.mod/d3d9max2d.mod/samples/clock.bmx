

Strict 
Import dbs.d3d9max2d
SetGraphicsDriver D3D9Max2DDriver()
'SetGraphicsDriver GLMax2DDriver()
'SetGraphicsDriver BufferedD3D7Max2DDriver()




'This function will be automagically called every Flip
Global lastime:Int=MilliSecs()
Global fps:Int
Function MyHook:Object( id:Int,data:Object,context:Object )
	Global count:Int
	If (MilliSecs()-lastime)>1000
		lastime=MilliSecs()
		fps=count
		count=0
	Else
		count:+1	
	End If	
End Function
'Add our hook to the system
AddHook FlipHook,MyHook


Graphics 320,240,0
SetOrigin 160,120
SetLineWidth 5
SetClsColor 255,244,0
While Not KeyHit(KEY_ESCAPE)
  Cls
  Local t=MilliSecs()
  DrawLine 0,0,120*Cos(t),120*Sin(t)
  DrawLine 0,0,80*Cos(t/60),80*Sin(t/60)
  DrawText fps,0,0
  Flip 0
Wend


