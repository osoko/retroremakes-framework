' This is an actor representing a star in our starfield
Type TStar Extends TActor

	Const MIN_SPEED:Int = 1
	Const MAX_SPEED:Int = 6
	
	Global starImage:TImage
	Global screenX:Int
	Global screenY:Int

	Field speed:Float
	
	Method New()
		If Not starImage
			starImage = rrGetResourceImage("resources/star.png")
		End If
		If Not screenX Then screenX = TProjectionMatrix.GetInstance().GetWidth()
		If Not screenY Then screenY = TProjectionMatrix.GetInstance().GetHeight()
		
		SetPosition(Rand(0, screenX), Rand(0, screenY))
		RandomiseSpeed()
	End Method
	
	Method Update()
		Super.Update()
		Move(0.0, speed)
		If currentPosition.y > screenY Then Reset()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		Interpolate(tweening)
		colour.Set()
		DrawImage(starImage, renderPosition.x, renderPosition.y)
	End Method
	
	Method Reset()
		SetPosition(Rand(0, screenX), 0 - ImageHeight(starImage))
		RandomiseSpeed()
	End Method
	
	Method RandomiseSpeed()
		speed = Rand(MIN_SPEED, MAX_SPEED)
		Local brightness:Int = speed * (255.0 / MAX_SPEED)
		colour.r = brightness
		colour.g = brightness
		colour.b = brightness		
	End Method
End Type
