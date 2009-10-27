rem
	bbdoc: Type description
end rem
Type TTitleScreen Extends TScreenBase

	Const MENU_ITEM_SPACING:Int = 10
	
	Field logo:TImageActor
	
	Field menuItems:TFontActor[]
	Field menuItemsText:String[] = ["Play Game", "High-Scores", "Quit"]
	Field menuItemsId:Int[] = [TModeMessageData.MODE_START_GAME, TModeMessageData.MODE_HIGH_SCORES, TModeMessageData.MODE_QUIT]
	Field activeMenuItem:Int
	Field activeMenuAnimation:TColourOscillatorAnimation
	
	Field scroller:TScroller

		
	' Here we're going to create an ImageActor to show our logo
	Method CreateLogoActor()
		logo = New TImageActor
		
		' Get the texture for the logo from the resouce manager as we've already loaded it
		logo.SetTexture(rrGetResourceImage("resources/logo.png"))
		logo.SetScale(2.5, 1.75)
		
		' Here we create a simple animation that scrolls the logo into position from the top
		' of the screen
		Local anim:TPointToPointPathAnimation = New TPointToPointPathAnimation
		Local midScreenX:Float = TProjectionMatrix.GetInstance().GetWidth() / 2.0
		anim.SetStartPosition(midScreenX, 0 - logo.GetTexture().width / 2.0)
		anim.SetEndPosition(midScreenX, 100)
		anim.SetTransitionTime(600.0)
		
		' Add the animation to the actor's animation manager
		logo.GetAnimationManager().AddAnimation(anim)
		
		' make sure it's visible immediately
		logo.SetVisible(True)
	End Method
	
	
	
	' Here we create our menu, built from Font Actors
	Method CreateMenuActors()
		activeMenuAnimation = New TColourOscillatorAnimation
		activeMenuAnimation.SetColourGen(rrGetResourceColourGen("resources/ActiveMenuColours.ini"))
	
		Local font:TImageFont = rrGetResourceImageFont("resources/ArcadeClassic.ttf", 48)
		SetImageFont(font)
		
		' work out the place to start drawing our menu to ensure it is centered on the screen
		Local screenMidX:Int = TProjectionMatrix.GetInstance().GetWidth() / 2.0
		Local screenMidY:Int = (TProjectionMatrix.GetInstance().GetHeight() - logo.GetTexture().height) / 2
		Local menuHeight:Int = (menuItemsText.Length * font.Height()) + ((menuItems.Length - 1) * MENU_ITEM_SPACING)
		Local itemY:Int = logo.GetTexture().height + screenMidY + (font.Height() / 2) - (menuHeight / 2)
		
		menuItems = New TFontActor[menuItemsText.Length]
	
		' Set the font, render text and position of all the menu items	
		For Local i:Int = 0 To menuItemsText.Length - 1
			menuItems[i] = New TFontActor
			menuItems[i].SetMidHandle(true)
			menuItems[i].SetFont(font)
			menuItems[i].SetText(menuItemsText[i])
			menuItems[i].SetPosition(screenMidX, itemY)
			itemY:+font.Height() + MENU_ITEM_SPACING
		Next
	End Method
	
	
	
	' Handle keyboard messages received
	Method HandleKeyboardMessages(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_UP
				If data.keyHits Then PreviousMenuItem()
			Case KEY_DOWN
				If data.keyHits Then NextMenuItem()
			Case KEY_ENTER
				If data.keyHits Then SelectMenuItem()
		End Select
	End Method
	
	
	
	' This is our switchboard where we listen for messages sent to the channels
	' we've subscribed to or directly to us
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardMessages(message)
		End Select
	End Method
	
	
	
	Method New()
		activeMenuItem = 0
		CreateLogoActor()
		CreateMenuActors()
		scroller = New TScroller
	End Method

	
	
	' Make the next menu item active, we display this by giving the font actor
	' a colour oscillator animation	
	Method NextMenuItem()
		' remove active animation
		UnsetActiveMenuAnimation()
		
		' make next item active (menu wraps)
		activeMenuItem:+1
		If activeMenuItem > menuItems.Length - 1 Then activeMenuItem = 0
		
		' add active animation
		SetActiveMenuAnimation()
	End Method
		
	
	
	' Make the previous menu item active, we display this by giving the font actor
	' a colour oscillator animation		
	Method PreviousMenuItem()
		' remove active animation
		UnsetActiveMenuAnimation()

		' make previous item active (menu wraps)
		activeMenuItem:-1
		If activeMenuItem < 0 Then activeMenuItem = menuItems.Length - 1

		' add active animation
		SetActiveMenuAnimation()
	End Method
	
	
	
	' We're not actually rendering anything ourselves here currently, but we could
	' if we wanted/needed to	
	Method Render(tweening:Double, fixed:Int)
	End Method
	
	
	
	' Reset the logo's position and animations to starting values
	' and add it to the relevant layer
	Method ResetLogo()
		' Set it's initial position off the top of the screen
		Local midScreenX:Float = TProjectionMatrix.GetInstance().GetWidth() / 2.0
		logo.SetPosition(midScreenX, 0 - ImageHeight(logo.GetTexture()))
		
		' Reset the animation manager so it will restart the animation sequence from the beginning	
		logo.GetAnimationManager().Reset()
		
		' Add it to the "front" layer
		theLayerManager.AddRenderObjectToLayerByName(logo, "front")
	End Method
	
	
	
	' Reset the menu to starting values and at the text actors
	' to the relevant layer
	Method ResetMenu()
		activeMenuItem = 0
		For Local i:Int = 0 To menuItems.Length - 1
			menuItems[i].GetAnimationManager().Remove()
			If activeMenuItem = i
				menuItems[i].GetAnimationManager().AddAnimation(activeMenuAnimation)
			EndIf
			menuItems[i].SetColour(New TColourRGB)
			theLayerManager.AddRenderObjectToLayerByName(menuItems[i], "middle")
		Next
	End Method
	
	
	
	' Reset the scroller to starting values and add it to the relevant layer
	Method ResetScroller()
		scroller.Reset
		theLayerManager.AddRenderObjectToLayerByName(scroller, "middle")
	End Method
	
	
	
	' When a menu item is selected we will broadcast a message to the game manager
	' telling it to change the currently running screen
	Method SelectMenuItem()
		Local message:TMessage = New TMessage
		message.SetMessageId(MSG_CHANGE_MODE)
		
		Local payload:TModeMessageData = New TModeMessageData
		payload.modeId = menuItemsId[activeMenuItem]
		
		message.SetData(payload)
		
		message.Broadcast(GAME_MANAGER_CHANNEL)
	End Method
	
	
	
	' Add the colour oscillation animation to the currently selected menu item
	Method SetActiveMenuAnimation()
		menuItems[activeMenuItem].GetAnimationManager().AddAnimation(activeMenuAnimation)
	End Method
	
	
	
	' This is called when the game manager wants us to start
	Method Start()
		' We want to react to key presses, so we'll subscribe to the input channel
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		ResetLogo()
		ResetMenu()
		ResetScroller()
	End Method
	
	
	
	' This is called when the game manager wants us to stop
	Method Stop()
		' unsubscribe from all channels so we don't receive messages when we are
		' not active
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
		
		' remove all our renderables from the layer manager
		theLayerManager.RemoveRenderObject(logo)
		For Local item:TFontActor = EachIn menuItems
			theLayerManager.RemoveRenderObject(item)
		Next
		theLayerManager.RemoveRenderObject(scroller)
		
		' Send a message to the game manager saying we're finished
		Finished()
	End Method
	
	
	
	' useful for debugging and logging
	Method ToString:String()
		Return "TitleScreen:" + Super.ToString()
	End Method
	
	
	
	
	' Remove the colour oscillation animation to the currently selected menu item
	' and set its colour to white
	Method UnsetActiveMenuAnimation()
		' remove the animation from the current active menu item
		menuItems[activeMenuItem].GetAnimationManager().Remove()
		
		' reset it's colour to white
		menuItems[activeMenuItem].SetColour(New TColourRGB)
	End Method

	
	
	' We're not actually updating anything ourselves here currently, but we could
	' if we wanted/needed to
	Method Update()
	End Method
	
End Type
