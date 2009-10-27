rem
	bbdoc: Type description
end rem
Type TPlayerBullet Extends TImageActor

	Const RELOAD_SPEED:Int = 400
	Const SPEED:Float = 15.0

	Global image:TImage
	Global nextBullet:Int
	
	Function Create:TPlayerBullet(position:TVector2D)
		If MilliSecs() < nextBullet Then Return Null
		nextBullet = MilliSecs() + RELOAD_SPEED
		Local bullet:TPlayerBullet = New TPlayerBullet
		bullet.SetTexture(image)
		bullet.ResetPosition(position.x, position.y)
		bullet.SetColour(New TColourRGB)
		bullet.GetColour().r = 255
		bullet.GetColour().g = 0
		bullet.GetColour().b = 0
		bullet.SetVisible(True)
		TLayerManager.GetInstance().AddRenderObjectToLayerByName(bullet, "middle")
		Return bullet
	End Function
	
	Method New()
		If Not image
			image = rrGetResourceImage("resources/bullet.png")
		End If
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		Super.Render(tweening, fixed)
	End Method
	
	Method Update()
		If GetCurrentPosition().y < 0 - GetTexture().height
			TLayerManager.GetInstance().RemoveRenderObject(Self)
		Else
			Super.Update()
			Move(0.0, -SPEED)
		End If
	End Method
End Type
