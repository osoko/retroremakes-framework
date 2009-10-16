Rem

	This GameManager class is used to manage the high-level flow
	of our game.

EndRem

Const GAME_MANAGER_CHANNEL:Int = 0

Const SCREEN_FINISHED:Int = 0

Type GameManager Extends TGameManager

	Field theLayerManager:TLayerManager
	Field theRegistry:TRegistry
	
	Method LoadResources()
		AutoImageFlags(FILTEREDIMAGE | MIPMAPPEDIMAGE)
		AutoMidHandle(True)
		rrLoadResourceImage("resources/star.png")
		rrLoadResourceImage("resources/logo.png")
	End Method
	
	Method MessageListener(message:TMessage)
		'TODO
	End Method
	
	Method New()
		' We'll keep local references to commonly used singletons to save typing
		theLayerManager = TLayerManager.GetInstance()
		theRegistry = TRegistry.GetInstance()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		'TODO
	End Method
	
	Method Start()
		' The Start() method is called after all engine services have been started, therefore
		' the graphics context has been create and all engine facilities should be available.
		' This is basically were we do our game initialisation, and kick things off.
		
		' First we'll load all the resources we're going to use in the game
		LoadResources()
	
		' First we will create a new message channel, our custom screen class will use this
		' channel to send us messages.
		TMessageService.GetInstance().CreateMessageChannel(GAME_MANAGER_CHANNEL, "GameManager")
		
		' Before we can hear any messages sent on the channel we need to subscribe ourselves
		' to it.
		TMessageService.GetInstance().SubscribeToChannel(GAME_MANAGER_CHANNEL, Self)
		
		' We will also create some layers that we will then use to add our renderable objects to
		' when we want them to be displayed and updated by the engine.
		'
		' Layers are rendered in numerical order by Id, so objects assigned to layer 0 will be drawn
		' before objects assigned to layer 10, etc.
		'
		' First we create a layer that we will add objects to that need to be drawn in the background
		theLayerManager.CreateLayer(0, "back")
		
		' This is the layer we'll use for our menus and the actual gameplay elements when the game
		' is actually playing
		theLayerManager.CreateLayer(10, "middle")

		' This is the layer we'll use for anything we want to appear in front of anything else
		theLayerManager.CreateLayer(10, "front")
						
		' Now we'll start adding a few essentials to these layers.  First off we have a parallax starfield
		' (you gotta have parallax starfields, it's the law). We always want this to be displayed so we're
		' not bothering keeping track of the object, we'll just let the layerManager do its thing with it
		theLayerManager.AddRenderObjectToLayerByName(New TStarfield, "back")
		
		' Now we'll create instances of our game screens and add them to the registry for easy access
		theRegistry.Add("TitleScreen", New TTitleScreen)
		
		'TEST
		theLayerManager.AddRenderObjectToLayerByName(TScreenBase(theRegistry.Get("TitleScreen")), "middle")
		TScreenBase(theRegistry.Get("TitleScreen")).Start()
		
	End Method
	
	Method Stop()
		'TODO
	End Method
	
	Method Update()
		'TODO
	End Method
	
End Type



