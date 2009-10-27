rem
	bbdoc: Type description
end rem
Type TPlayer Extends TImageActor


	Const STARTING_LIVES:Int = 3
	Const SPEED:Float = 4.0

	Field livesRemaining:Int
	Field score:TScore
		
	Method Render(tweening:Double, fixed:Int)
		Super.Render(tweening, fixed)
	End Method

	Method Reset()
		livesRemaining = STARTING_LIVES
		score.Init()
	End Method
	
	Method New()
		score = New TScore
		SetTexture(rrGetResourceImage("resources/player.png"))
		SetPosition(TProjectionMatrix.getInstance().GetWidth() / 2.0, TProjectionMatrix.getInstance().GetHeight() - GetTexture().height - 10.0)
		SetColour(New TColourRGB)
		GetColour().r = 0
		GetColour().g = 128
		GetColour().b = 255
		SetVisible(True)
	End Method
	
	Method Update()
		Super.Update()
		If KeyDown(KEY_LEFT)
			If GetCurrentPosition().x > 0.0 + GetTexture().width Then Move(-SPEED, 0.0)
		End If
		If KeyDown(KEY_RIGHT)
			If GetCurrentPosition().x < TProjectionMatrix.GetInstance().GetWidth() - GetTexture().width Then Move(SPEED, 0.0)
		End If
		If KeyDown(KEY_SPACE)
			TPlayerBullet.Create(GetCurrentPosition())
		End If
	End Method
	
End Type
