' This is the class that runs our starfield background (yay!)
' It derived from a TRenderable object as we want to be able to
' assign it to a layer which will then Update and Render
Type TStarfield extends TRenderable

	Const MAX_STARS:Int = 80

	Field stars:TStar[]
	
	' Default constructor
	' Here we just create the amount of stars we need
	Method New()
		stars = New TStar[MAX_STARS]
		
		For Local i:Int = 0 To MAX_STARS - 1
			stars[i] = New TStar
		Next
	End Method

	
	
	' Here we just loop through all of our stars and call their
	' own Render method. In this case the Render method called
	' is the star's parent TImageActor render method
	Method Render(tweening:Double, fixed:Int = False)
		For Local i:Int = 0 To MAX_STARS - 1
			stars[i].Render(tweening:Double, fixed:Int = False)
		Next
	End Method
	
	
	
	' Useful for logging/debugging
	Method ToString:String()
		Return "Starfield:" + Super.ToString()
	End Method
			
	
	
	' In our Update method we loop through all the starts and
	' call their own update method.
	Method Update()
		For Local i:Int = 0 To MAX_STARS - 1
			stars[i].Update()
		Next
	End Method
	
End Type
