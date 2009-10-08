Rem
	bbdoc: Sprite class using an internal BlitzMax #TImage
End Rem
Type TImageActor Extends TActor

	Field texture_:TImage
	Field frameCount_:Int
	Field currentFrame_:Int

	
	Method GetFrameCount:Int()
		Return frameCount_
	End Method
	
	
	
	Method New()
		currentFrame_ = 0
	End Method
	
	
	
	Method SetCurrentFrame(currentFrame:Int)
		currentFrame_ = currentFrame
	End Method

	
	
	Method RandomFirstFrame()
		If texture_
			currentFrame_ = Rnd(0, frameCount_ - 1)
		End If
	End Method
	
	
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
		SetRenderState()
		If texture_ And IsVisible()
			if fixed
				DrawImage(texture_, Int(renderPosition.x), Int(renderPosition.y), currentFrame_)
			else
				DrawImage(texture_, renderPosition.x, renderPosition.y, currentFrame_)
			endif
		EndIf
	End Method

	
	
	Method SetTexture(texture:TImage)
		texture_ = texture
		frameCount_ = texture_.frames.Length
	End Method
End Type
