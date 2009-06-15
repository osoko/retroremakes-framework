'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem

Const SPR_ANIM_FWD:Int = $1
Const SPR_ANIM_REV:Int = $2

Const SPR_ANIM_PINGPONG:Int = $1
Const SPR_ANIM_LOOP:Int = $2
Const SPR_ANIM_ONESHOT:Int = $4

Type TImageAnimSprite' Extends TImageSprite

	Field frameCount:Int
	Field firstFrame:Int
	Field lastFrame:Int
	Field currentFrame:Int
	
	Field playing:Int = True
	
	Field animMode:Int
	Field animDirection:Int
	
	Field animFPS:Float
	
	Field animFrameDelta:Double
	Field animAccumulator:Double
	Field nowTime:Double
	Field newTime:Double
	Field dt:Double
	
	Method New()
		animMode = SPR_ANIM_LOOP
		animDirection = SPR_ANIM_FWD
	End Method

	Function CreateImageAnimSprite:TImageAnimSprite(image:TImage, animFPS:Float = 60.0)
		Local logicFreq:Double = rrGetUpdateFrequency()
		Local tempFreq:Double = 1000.0 / animFPS
		Local sprite:TImageAnimSprite = New TImageAnimSprite

		sprite.texture = image
		sprite.frameCount = image.frames.Length
		sprite.currentFrame = 0
		sprite.firstFrame = 0
		sprite.lastFrame = image.frames.Length
		sprite.animFPS = animFPS
		sprite.animFrameDelta = logicFreq * (tempFreq / logicFreq)
		sprite.colour.r = 255
		sprite.colour.g = 255
		sprite.colour.b = 255
		sprite.colour.a = 1.0		
		Return sprite
	End Function
	
	Method Update()
		If Not nowTime
			nowTime = rrMillisecs()
		End If
		
		newTime = rrMillisecs()

		Local deltaTime:Double = newTime - nowTime
		nowTime = newTime
		
		animAccumulator:+deltaTime
		While animAccumulator > animFrameDelta
			animAccumulator:-animFrameDelta

			' Check to see if the animation is playing before we update it
			If playing
				
				' Looping animation mode
				If animMode = SPR_ANIM_LOOP
					If animDirection = SPR_ANIM_FWD
						currentFrame:+1
						If currentFrame > lastFrame Then currentFrame = firstFrame
					Else If animDirection = SPR_ANIM_REV
						currentFrame:-1
						If currentFrame < firstFrame Then currentFrame = lastFrame
					EndIf
				EndIf

				' PingPong animation mode
				If animMode = SPR_ANIM_PINGPONG
					If animDirection = SPR_ANIM_FWD
						currentFrame:+1
						If currentFrame = lastFrame Then animDirection = SPR_ANIM_REV
					Else If animDirection = SPR_ANIM_REV
						currentFrame:-1
						If currentFrame = firstFrame Then animDirection = SPR_ANIM_FWD
					EndIf
				EndIf
				
				' OneShot animation mode, stops playing automatically when it reaches the final frame
				If animMode = SPR_ANIM_ONESHOT
					If animDirection = SPR_ANIM_FWD
						currentFrame:+1
						If currentFrame = lastFrame Then playing = False
					Else If animDirection = SPR_ANIM_REV
						currentFrame:-1
						If currentFrame = firstFrame Then playing = False
					EndIf
				EndIf				
										
			End If
			
		Wend
	End Method

		
	Method Render(tweening:Double)
		Interpolate(tweening)
		SetRenderState()
		DrawImage(texture, drawPosition.x, drawPosition.y, currentFrame)
	End Method

	Method IsPlaying:Int()
		Return playing
	End Method
	
End Type

