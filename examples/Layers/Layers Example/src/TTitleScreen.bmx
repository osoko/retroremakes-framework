rem
	bbdoc: Type description
end rem
Type TTitleScreen Extends TScreenBase

	Field logo:TImageActor
	
	Method CreateLogoActor()
		logo = New TImageActor
		logo.SetTexture(rrGetResourceImage("resources/logo.png"))
		
		Local anim:TPointToPointPathAnimation = New TPointToPointPathAnimation
		anim.SetStartPosition(400, TGraphicsService.GetInstance().height + ImageHeight(logo.texture_))
		anim.SetEndPosition(400, 60)
		anim.SetTransitionTime(2000.0)
		
		logo.animationManager.AddAnimation(anim)
		
		logo.SetVisible(True)
	End Method
	
	Method MessageListener(message:TMessage)
		
	End Method
	
	Method New()
		CreateLogoActor()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
	End Method
	
	Method Start()
		logo.animationManager.Reset()
		TLayerManager.GetInstance().AddRenderObjectToLayerByName(logo, "front")
	End Method
	
	Method Stop()
		TLayerManager.GetInstance().RemoveRenderObject(logo)
	End Method
	
	Method Update()
		
	End Method
	
End Type
