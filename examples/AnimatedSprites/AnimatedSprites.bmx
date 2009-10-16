Rem
'
' Vernimb sprite design and IP copyright Stoo Cambridge / www.hobeka.com from Blobbit Dash & Blobbit Push,
' www.blobbitworld.com  used with permission for non commercial use
'
endrem

SuperStrict

Framework retroremakes.rrfw

Incbin "media/Vernimb3_hopdown_anim.png"

rrUseExeDirectoryForData()

TGameEngine.GetInstance().SetGameManager(New GameManager)

TGameEngine.GetInstance().Run()


Type GameManager Extends TGameManager

	Const NUM_SPRITES:Int = 25
	
	Const text1:String = "Vernimb sprite design and IP copyright Stoo Cambridge / www.hobeka.com"
	Const text2:String = "from Blobbit Dash & Blobbit Push, www.blobbitworld.com"
	Const text3:String = "used with permission for non commercial use"
	
	Field spriteImage:TImage
	
	Field cornerX:Int[] = New Int[4]
	Field cornerY:Int[] = New Int[4]
		
	
	' Here we create all our sprites and add them to a render layer
	Method CreateAllSprites()
		For Local i:Int = 1 To NUM_SPRITES
			' Create a new TImageSprite
			Local sprite:TImageActor = New TImageActor
			
			' Give it the texture we want
			sprite.SetTexture(spriteImage)
			
			' Randomize the first frame of the animation
			sprite.RandomFirstFrame()
			
			' Set it's starting position
			Local x:Int = Rand(0, rrGetGraphicsWidth() - spriteImage.Width)
			Local y:Int = Rand(0, rrGetGraphicsHeight() - spriteImage.Height)
			sprite.SetPosition(x, y)
			
			' Create the animations for this sprite
			CreateAnimations(sprite)
			
			' Finally add it to the sprite manager.
			TLayerManager.GetInstance().AddRenderObjectToLayerById(sprite, 0)
		Next
	End Method
	
	
	
	' Each sprite has a series of animations assigned, these are created here
	Method CreateAnimations(sprite:TImageActor)

		' Get a handle to the sprite's Animation Manager
		Local animationManager:TAnimationManager = sprite.GetAnimationManager()
		
		' Create our first animation.  This is a composite type
		' where it will run all animations we assign to it at the
		' same time.
		Local compAnim:TCompositeAnimation = New TCompositeAnimation
		' add the composite animation to the sprite's animation manager
		animationManager.AddAnimation(compAnim)
				
		' The TLoopedFrameAnimation will handle the actual texture animation
		Local frameAnim:TLoopedFrameAnimation = New TLoopedFrameAnimation
		frameAnim.SetFirstFrame(sprite.currentFrame_)
		' Set the animation speed in FPS
		frameAnim.SetSpeed(Rand(10, 20))
		' Add the animation to the composite animation
		compAnim.AddAnimation(frameAnim)
		
		' We want to delay the start of the other animation in the composite
		' so we create a TDelayedAnimation
		Local delayAnim:TDelayedAnimation = New TDelayedAnimation
		' Specify how long you want to delay the following animation in ms.
		' we'll delay randomly between 1 and 10 seconds.
		delayAnim.SetDelayTime(Rand(1000, 10000))
		' Add the animation to the composite
		compAnim.AddAnimation(delayAnim)
		
		' We now need to add the animations we wanted to delay to delayAnim
		' In this case we want a Looped Animation which will cycle through
		' All animations we assign to it
		Local loopAnim:TLoopedAnimation = New TLoopedAnimation
		' We're going to make each sprite visit each corner of the screen,
		' returning to their original position between each, and this will
		' loop forever.
		Local startX:Float = sprite.currentPosition.x
		Local startY:Float = sprite.currentPosition.y
		
		' randomise the first corner
		Local corner:Int = Rand(0, 3)
		For Local i:Int = 1 To 4
			' create a point to point path animation, moving from the sprites
			' starting position and ending at one of the corners.
			Local path1:TPointToPointPathAnimation = New TPointToPointPathAnimation
			path1.SetStartPosition(startX, startY)
			path1.SetEndPosition(cornerX[corner], cornerY[corner])
			' Randomize speed
			path1.SetTransitionTime(Rand(1000, 8000))

			' Add to looped animation
			loopAnim.AddAnimation(path1)
			
			' create a point to point path animation, moving from the current corner
			' back to the starting position.
			Local path2:TPointToPointPathAnimation = New TPointToPointPathAnimation
			path2.SetStartPosition(cornerX[corner], cornerY[corner])
			path2.SetEndPosition(startX, startY)
			' Randomize speed
			path2.SetTransitionTime(Rand(1000, 8000))
			
			' Add to looped animation
			loopAnim.AddAnimation(path2)
			
			' Next corner
			corner:+1
			If corner > 3 Then corner = 0
		Next
		
		' Add the looped animation to the delayed animation
		delayAnim.SetAnimation(loopAnim)
		
	End Method
	
	
	
	Method Start()
		'Called when switching to this GameState
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		
		TLayerManager.GetInstance().CreateLayer(0, "my-layer")
		
		'Called after the Graphics device has been created
		rrLoadResourceAnimImage("incbin::media/Vernimb3_hopdown_anim.png", 64, 72, 0, 5, FILTEREDIMAGE | MIPMAPPEDIMAGE)
		spriteImage = rrGetResourceAnimImage("incbin::media/Vernimb3_hopdown_anim.png")
		
		cornerX = [0, rrGetGraphicsWidth() - spriteImage.Width, rrGetGraphicsWidth() - spriteImage.Width, 0]
		cornerY = [0, 0, rrGetGraphicsHeight() - spriteImage.Height, rrGetGraphicsHeight() - spriteImage.Height]
		
		CreateAllSprites()		
	End Method

	
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeFromChannel(CHANNEL_INPUT, Self)
	End Method
	
	
	
	Method HandleKeyboardInput(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.Key
			Case KEY_ESCAPE
				rrEngineStop()
		End Select
	End Method

	
	
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardInput(message)
		EndSelect
	End Method
		
	
	
	' To keep things simple, we'll draw the copyright text in the Game Manager's render method
	' this means it will always be the last thing drawn.
	Method Render(tweening:Double, fixed:Int = False)
		DrawText(text1, 0, rrGetGraphicsHeight() - (TextHeight(text1) * 3))
		DrawText(text2, 0, rrGetGraphicsHeight() - (TextHeight(text2) * 2))
		DrawText(text3, 0, rrGetGraphicsHeight() - (TextHeight(text3) * 1))
	End Method		

	
	
	Method Update()
		' We don't need to do anything in the update look in this example
	End Method
	
End Type
