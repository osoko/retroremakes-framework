Rem

	This GameManager class is used to manage the high-level flow
	of our game.

EndRem

Const GAME_MANAGER_CHANNEL:Int = 0

Const MSG_SCREEN_FINISHED:Int = 0
Const MSG_CHANGE_MODE:Int = 1
Const MSG_LEVEL_FINISHED:Int = 2
Const MSG_GAME_OVER:Int = 3

Type GameManager Extends TGameManager

	' This is the currently active screen
	Field currentScreen:TScreenBase
	
	' A couple of shortcuts to frequently used services
	Field theEngine:TGameEngine
	Field theLayerManager:TLayerManager
	Field theRegistry:TRegistry
	
	
	
	' This method switches screens. First it calls the Stop() method of the currently
	' running screen (if there is one), and then retrieves the requested screen from
	' the registry, adds it to a layer and calls its Start() method. Any existing
	' screen is not removed from the layer manager here as it may be doing futher
	' work (fades, wipes, etc.), so we'll remove it once we receive a SCREEN_FINISHED
	' message from it.
	Method ChangeScreen(screen:String)
		LogInfo(ToString() + " changing to requested screen: " + screen)
		If currentScreen
			LogInfo(ToString() + " stopping screen: " + currentScreen.ToString())
			currentScreen.Stop()
		EndIf
		
		currentScreen = TScreenBase(theRegistry.Get(screen))
		
		If currentScreen
			LogInfo(ToString() + " adding screen to layer manager: " + currentScreen.ToString())
			theLayerManager.AddRenderObjectToLayerByName(currentScreen, "back")
			LogInfo(ToString() + " starting screen: " + currentScreen.ToString())
			currentScreen.Start()
		End If
	End Method
	
	
	
	' Here we just load all the resources we're going to need via the
	' resource manager. That way any objects that needs to use them can
	' retrieve them when required.
	Method LoadResources()
		AutoImageFlags(FILTEREDIMAGE | MIPMAPPEDIMAGE)
		AutoMidHandle(True)
		rrLoadResourceColourGen("resources/ActiveMenuColours.ini")
		rrLoadResourceColourGen("resources/FastFire.ini")
		rrLoadResourceColourGen("resources/QuickerThrob.ini")
		rrLoadResourceImage("resources/alien.png")
		rrLoadResourceImage("resources/bullet.png")
		rrLoadResourceImage("resources/logo.png")
		rrLoadResourceImage("resources/player.png")
		rrLoadResourceImage("resources/star.png")
		rrLoadResourceImageFont("resources/ArcadeClassic.ttf", 48)
		rrLoadResourceImageFont("resources/ArcadeClassic.ttf", 36)
	End Method
	
	
	
	' This is where we process any keyboard messages we have received.
	Method HandleKeyboardMessages(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_ESCAPE
				If data.keyHits Then Quit()
			Case KEY_P
				If data.keyHits Then Pause()
		End Select
	End Method
	
	
	
	' This is where we process any mode change messages
	Method HandleModeChange(message:TMessage)
		Local data:TModeMessageData = TModeMessageData(message.data)
		Select data.modeId
			Case TModeMessageData.MODE_START_GAME
				' Start the Game
				ChangeScreen("GameplayScreen")
			Case TModeMessageData.MODE_HIGH_SCORES
				' Show the high-score table
				ChangeScreen("HighScoreTableScreen")
			Case TModeMessageData.MODE_QUIT
				Quit()
			Case TModeMessageData.MODE_TITLE_SCREEN
				ChangeScreen("TitleScreen")
		End Select
	End Method	
	
	
	
	' This is where we process screen finished messages
	Method HandleScreenFinished(message:TMessage)
		' very simply, we remove the sender of the message from the layer manager
		LogInfo(ToString() + " received finished message from screen: " + message.sender.ToString())
		If message.sender Then theLayerManager.RemoveRenderObject(TRenderable(message.sender))
	End Method
	
		
	
	' This is our message switchboard, where we decide how to process all
	' the incoming messages
	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardMessages(message)
			Case MSG_CHANGE_MODE
				HandleModeChange(message)
			Case MSG_SCREEN_FINISHED
				HandleScreenFinished(message)
		End Select
	End Method
	
	
	
	Method New()
		' We'll keep local references to commonly used singletons to save typing
		theEngine = TGameEngine.GetInstance()
		theLayerManager = TLayerManager.GetInstance()
		theRegistry = TRegistry.GetInstance()
	End Method
	
	
	
	Method Pause()
		theEngine.SetPaused(theEngine.GetPaused() ~ 1)
	End Method
	
	
	
	Method Quit()
		theEngine.Stop()
	End Method
	
	
	
	Method Render(tweening:Double, fixed:Int)
		'TODO
	End Method
	
	

	' The Start() method is called after all engine services have been started, therefore
	' the graphics context has been create and all engine facilities should be available.
	' This is basically were we do our game initialisation, and kick things off.		
	Method Start()
		
		' First we'll load all the resources we're going to use in the game
		LoadResources()

		' First we will create a new message channel, our custom screen class will use this
		' channel to send us messages.
		TMessageService.GetInstance().CreateMessageChannel(GAME_MANAGER_CHANNEL, "GameManager")
		
		' Before we can hear any messages sent on the channel we need to subscribe ourselves
		' to it.
		TMessageService.GetInstance().SubscribeToChannel(GAME_MANAGER_CHANNEL, Self)
		
		' We're also interested in listening for message on the input channel
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		
		' We will also create some layers that we will then use to add our renderable objects to
		' when we want them to be displayed and updated by the engine.
		'
		' Layers are rendered in numerical order by Id, so objects assigned to layer 0 will be drawn
		' before objects assigned to layer 10, etc.
		'
		' First we add a layer that we will add objects to that need to be drawn in the background
		theLayerManager.CreateLayer(10, "back")
		
		' This is the layer we'll use for our menus and the actual gameplay elements when the game
		' is actually playing
		theLayerManager.CreateLayer(20, "middle")

		' This is the layer we'll use for anything we want to appear in front of anything else
		theLayerManager.CreateLayer(30, "front")
						
		' Now we'll start adding a few essentials to these layers.  First off we have a parallax starfield
		' (you gotta have parallax starfields, it's the law). We always want this to be displayed so we're
		' not bothering keeping track of the object, we'll just let the layerManager do its thing with it
		theLayerManager.AddRenderObjectToLayerByName(New TStarfield, "back")
		
		' Now we'll create instances of our game screens and add them to the registry for easy access
		theRegistry.Add("TitleScreen", New TTitleScreen)
		theRegistry.Add("HighScoreTableScreen", New THighScoreTableScreen)
		theRegistry.Add("GameplayScreen", New TGameplayScreen)
		
		ChangeScreen("TitleScreen")
	End Method
	
	
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
	End Method
	
	
	
	Method ToString:String()
		Return "Game Manager:" + Super.ToString()
	End Method
	
	
	
	Method Update()
		'TODO
	End Method
	
End Type



