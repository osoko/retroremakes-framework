' This is an image actor representing a star in our starfield
Type TStar Extends TImageActor

	Const MIN_SPEED:Int = 1
	Const MAX_SPEED:Int = 6
	
	Global screenX:Int
	Global screenY:Int

	Field speed:Float
	
	
	
	' Default constructor.
	Method New()
		' We'll need these values frequently, so to improve performance we'll
		' store copies of them so that all stars can easily access
		If Not screenX Then screenX = TProjectionMatrix.GetInstance().GetWidth()
		If Not screenY Then screenY = TProjectionMatrix.GetInstance().GetHeight()

		' Set the texture for the stars to the star image that has been loaded
		' by the resource manager
		SetTexture(rrGetResourceImage("resources/star.png"))
		
		' Set a random initial position and speed
		SetPosition(Rand(0, screenX), Rand(0, screenY))
		RandomiseSpeed()
	End Method

	
	
	' This picks a random speed in the correct range and then updates the colour
	' so that slower stars are darker than the faster ones.
	Method RandomiseSpeed()
		speed = Rand(MIN_SPEED, MAX_SPEED)
		Local brightness:Int = speed * (255.0 / MAX_SPEED)
		GetColour().r = brightness
		GetColour().g = brightness
		GetColour().b = brightness
	End Method

	
	
	' This method is called when a star has dropped off the bottom of the screen.
	' It resets its Y value to to top and randomises its X position and speed,
	' this way we don't have any repeating patterns in the starfield
	Method Reset()
		ResetPosition(Rand(0, screenX), 0 - GetTexture().height)
		RandomiseSpeed()
	End Method
	

			
	' The update method first calls its parent's update method which handles things
	' like updating the image actors previous position so that we can do render tweening
	' to smooth at glitches in framerate.
	' Then we just update the position, and if we've dropped off the bottom of the screen
	' reset the star back to the top again
	Method Update()
		Super.Update()
		Move(0.0, speed)
		If GetCurrentPosition().y > screenY Then Reset()
	End Method
	
End Type
