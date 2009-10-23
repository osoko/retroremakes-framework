rem
	bbdoc: Type description
end rem
Type TPlayer Extends TImageActor

	Const STARTING_LIVES:Int = 3
	Const SPEED:Float = 2.0

	Field score:TScore
	Field livesRemaining:Int
	
	Method Render(tweening:Double, fixed:Int)
		
	End Method

	Method Reset()
		livesRemaining = STARTING_LIVES
		score.Init()
	End Method
	
	Method New()
		score = New TScore
		SetTexture(rrGetResourceImage("resources/player.png"))
		SetPosition(TProjectionMatrix.getInstance().GetWidth() / 2.0, TProjectionMatrix.getInstance().GetHeight() - Self.texture_.height)
		SetVisible(True)
	End Method
	
	Method Update()
		
	End Method
	
End Type
