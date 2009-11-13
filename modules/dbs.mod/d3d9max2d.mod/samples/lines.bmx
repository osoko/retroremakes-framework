' this is a test to see that lines are drawn all the same length.   I had report they were not
' this demo should confirm the line is the same for all drivers
'
Strict 
Import dbs.d3d9max2d


'SetGraphicsDriver D3D9Max2DDriver()
SetGraphicsDriver GLMax2DDriver()




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


Graphics 640,480,0
SetLineWidth 4
SetClsColor 0,0,0
While Not KeyHit(KEY_ESCAPE)
  Cls 
  DrawLine 0,320,640,0
  DrawText fps,0,460
  Flip 0
Wend


