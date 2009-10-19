rem
	bbdoc: Type description
end rem
Type TTitleScreen Extends TScreenBase

	Const MENU_ITEM_SPACING:Int = 10
	
	Field theLayerManager:TLayerManager
	
	Field logo:TImageActor
	
	Field menuItems:TFontActor[]
	Field menuItemsText:String[] = ["Play Game", "High-Scores", "Quit"]
	Field activeMenuItem:Int
	Field activeMenuAnimation:TColourOscillatorAnimation
	
	Field scroller:TScroller
	
	' Here we're going to create an ImageActor to show our logo
	Method CreateLogoActor()
		logo = New TImageActor
		
		' Get the texture for the logo from the resouce manager as we've already loaded it
		logo.SetTexture(rrGetResourceImage("resources/logo.png"))
		logo.SetScale(2.5, 1.75)
		
		Local anim:TPointToPointPathAnimation = New TPointToPointPathAnimation
		Local midScreenX:Float = TGraphicsService.GetInstance().width / 2
		anim.SetStartPosition(midScreenX, 0 - ImageHeight(logo.texture_))
		anim.SetEndPosition(midScreenX, 100)
		anim.SetTransitionTime(600.0)
		
		logo.animationManager.AddAnimation(anim)
		
		logo.SetVisible(True)
	End Method
	
	Method CreateMenuActors()
		activeMenuAnimation = New TColourOscillatorAnimation
		activeMenuAnimation.SetColourGen(rrGetResourceColourGen("resources/ActiveMenuColours.ini"))
	
		Local font:TImageFont = rrGetResourceImageFont("resources/ArcadeClassic.ttf", 48)
		SetImageFont(font)
		
		' work out the place to start drawing our menu to ensure it is centered on the screen
		Local screenMidX:Int = TGraphicsService.GetInstance().width / 2
		Local screenMidY:Int = (TGraphicsService.GetInstance().height - logo.texture_.height) / 2
		Local menuHeight:Int = (menuItemsText.Length * font.Height()) + ((menuItems.Length - 1) * MENU_ITEM_SPACING)
		Local itemY:Int = logo.texture_.height + screenMidY - (menuHeight / 2)
		
		menuItems = New TFontActor[menuItemsText.Length]
		
		For Local i:Int = 0 To menuItemsText.Length - 1
			menuItems[i] = New TFontActor
			menuItems[i].SetFont(font)
			menuItems[i].SetText(menuItemsText[i])
			menuItems[i].SetPosition(screenMidX - (TextWidth(menuItemsText[i]) / 2), itemY)
			itemY:+font.Height() + MENU_ITEM_SPACING
		Next
	End Method
	
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
	
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardMessages(message)
		End Select
	End Method
	
	Method New()
		theLayerManager = TLayerManager.GetInstance()
		activeMenuItem = 0
		CreateLogoActor()
		CreateMenuActors()
		scroller = New TScroller
	End Method
	
	Method NextMenuItem()
		menuItems[activeMenuItem].animationManager.Remove()
		menuItems[activeMenuItem].SetColour(New TColourRGB)
		activeMenuItem:+1
		If activeMenuItem > menuItems.Length - 1 Then activeMenuItem = 0
		SetActiveMenuAnimation()
	End Method
		
	Method PreviousMenuItem()
		menuItems[activeMenuItem].animationManager.Remove()
		menuItems[activeMenuItem].SetColour(New TColourRGB)
		activeMenuItem:-1
		If activeMenuItem < 0 Then activeMenuItem = menuItems.Length - 1
		SetActiveMenuAnimation()
	End Method
	
	Method Render(tweening:Double, fixed:Int)
		' We're not actually rendering anything ourselves here currently, but we could
		' if we wanted/needed to
	End Method
	
	Method ResetLogo()
		' Set it's initial position off the bottom of the screen
		logo.SetPosition(400, 0 - ImageHeight(logo.texture_))
		
		' Reset the animation manager so it will restart the animation sequence from the beginning	
		logo.animationManager.Reset()
		
		' Add it to the "front" layer
		theLayerManager.AddRenderObjectToLayerByName(logo, "front")
	End Method
	
	Method ResetMenu()
		activeMenuItem = 0
		For Local i:Int = 0 To menuItems.Length - 1
			menuItems[i].animationManager.Remove()
			If activeMenuItem = i
				menuItems[i].animationManager.AddAnimation(activeMenuAnimation)
			EndIf
			theLayerManager.AddRenderObjectToLayerByName(menuItems[i], "middle")
		Next
	End Method
	
	Method ResetScroller()
		scroller.Reset
		theLayerManager.AddRenderObjectToLayerByName(scroller, "middle")
	End Method
	
	Method SelectMenuItem()
		'TODO: Activate the menu item	
	End Method
	
	Method SetActiveMenuAnimation()
		menuItems[activeMenuItem].animationManager.AddAnimation(activeMenuAnimation)
	End Method
	
	Method Start()
		' We want to react to key presses, so we'll subscribe to the input channel
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		ResetLogo()
		ResetMenu()
		ResetScroller()
	End Method
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
		theLayerManager.RemoveRenderObject(logo)
		For Local item:TFontActor = EachIn menuItems
			theLayerManager.RemoveRenderObject(item)
		Next
		theLayerManager.RemoveRenderObject(scroller)
	End Method
	
	Method Update()
		' We're not actually updating anything ourselves here currently, but we could
		' if we wanted/needed to
	End Method
	
End Type
