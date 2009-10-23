
Type TStarfield extends TRenderable

	Const MAX_STARS:Int = 100

	Field stars:TStar[]
	
	Method New()
		stars = New TStar[MAX_STARS]
		
		For Local i:Int = 0 To MAX_STARS - 1
			stars[i] = New TStar
		Next
	End Method
	
	Method Update()
		For Local i:Int = 0 To MAX_STARS - 1
			stars[i].Update()
		Next
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		For Local i:Int = 0 To MAX_STARS - 1
			stars[i].Render(tweening:Double, fixed:Int = False)
		Next
	End Method
	
	Method ToString:String()
		Return "Starfield:" + Super.ToString()
	End Method
	
End Type
