Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type MyGameManager Extends TGameManager
	
	Field menuManager:TMenuManager
	Field layerManager:TLayerManager

	Method Quit()
		TGameEngine.GetInstance().Stop()
	End Method

	Method New()
	End Method
		
	Method Render(tweening:Double, fixed:Int)
		menuManager.Render(tweening, fixed)
		If TGameEngine.GetInstance().GetPaused()
			DrawText("Paused", 0, 100)
		End If
	End Method

	' The Start() method is called after all engine services have been started, therefore
	' the graphics context has been create and all engine facilities should be available.
	' This is basically were we do our game initialisation, and kick things off.		
	Method Start()
		SetUpMenus()

		'layerManager = New TLayerManager
		'layerManager.CreateLayer(0, "main")
		'layerManager.AddRenderableToLayerById(menuManager, 0)

		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)			' get keyboard input
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_MENU, Self)			' get messages from menu action items
	End Method
		
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
	End Method

	Method MessageListener(message:TMessage)
		Select message.messageID
			Case MSG_KEY
				HandleKeyboardMessages(message)
			Case MSG_MENU
				HandleMenuMessages(message)
		End Select
	End Method
	
	Method HandleKeyboardMessages(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_UP
				If data.keyHits Then menuManager.PreviousItem()
			Case KEY_DOWN
				If data.keyHits Then menuManager.NextItem()
			Case KEY_LEFT
				If data.keyHits Then menuManager.PreviousOption()
			Case KEY_RIGHT
				If data.keyHits Then menuManager.NextOption()
			Case KEY_ENTER
				If data.keyHits Then menuManager.DoItemAction()
			Case KEY_P
				If data.keyHits Then TGameEngine.GetInstance().SetPaused(True)
			Case KEY_U
				If data.keyHits Then TGameEngine.GetInstance().SetPaused(False)
		End Select
	End Method
	
	Method HandleMenuMessages(message:TMessage)
		Local data:TMenuMessageData = TMenuMessageData(message.data)
		Select data.action
			Case MENU_ACTION_QUIT
				Quit()
			Case MENU_ACTION_GRAPHICS_APPLY						' apply the set options in the graphics menu (built-in menu)
				menuManager.ApplyGraphicsMenu()
		End Select
	End Method
		
		
	Method SetUpMenus()
		menuManager = TMenuManager.GetInstance()
		Local m:TMenu
		Local a:TActionMenuItem
		Local s:TSubMenuItem
		Local i:TOptionMenuItem
		Local o:TMenuOption
		
		'create main menu
		m = New TMenu
		m.SetLabel("Main Menu")

		'set ugly color to footer!
		m.SetFooterColor(255, 0, 0)
		menuManager.AddMenu(m)
		
		'change vertical position a bit
		menuManager.SetMenuYpos(rrGetGraphicsHeight() - 300)
		
		a = New TActionMenuItem
		a.SetText("Start", "begin the game")
		
		'make this item create a game start message. HandleMenuMessages() handles these...
		a.SetAction(MENU_ACTION_START)
		menumanager.additemtomenu(m, a)
		
		s = New TSubMenuItem
		s.SetText("Options", "configure stuff")
		
		'this item send you to the options menu.
		s.SetNextMenu("Options")
		menumanager.additemtomenu(m, s)
		
		a = New TActionMenuItem
		a.SetText("Exit", "chicken out")
		
		' make this menu item create a game quit message.
		a.SetAction(MENU_ACTION_QUIT)
		menumanager.additemtomenu(m, a)
		
		'
		'options menu
		
		m = New TMenu
		m.SetLabel("Options")
		
		'set ugly menu title color !		
		m.SetLabelColor(255, 255, 0)

		'disable animation in this menu
		m.SetActiveItemAnimation(False)

		'items have another color as well. don't make this the same color as your selection color :)		
		m.SetItemColor(255, 0, 255)
		menuManager.AddMenu(m)

		s = New TSubMenuItem
		s.SetText("Graphics", "configure screen stuff")
		
		' name of built-in menu. don't change. the menu is created at the bottom of this method.
		s.SetNextMenu("Configure Graphics")
		menumanager.additemtomenu(m, s)
		
		i = New TOptionMenuItem
		i.SetText("Sillyness", "left and right to select sillyness")
		menumanager.additemtomenu(m, i)
		o = New TMenuOption
		o.SetLabel("Reasonable")
		i.AddOption(o)
		o = New TMenuOption
		o.SetLabel("Totally")
		i.AddOption(o)
		o = New TMenuOption
		o.SetLabel("Insane")
		i.AddOption(o)
		
		' this item now saves selected option to the config file (ini file)		
		i.EnableGameSetting()
				
		s = New TSubMenuItem
		s.SetText("Back", "back to main menu")
		
		' this forces a 'go back'
		s.SetNextMenu("back")
		menumanager.additemtomenu(m, s)
		
		'create built-in menu called "Configure Graphics"... only show 60 hz modes, and don't care about depth.
		Local menu:TMenu = menuManager.BuildGraphicsMenu(60, 0)
		
		'no animations on the built in menu as well please!
		menu.SetActiveItemAnimation(False)
		
		'set the menu to start with. use the label to find it.
		menuManager.SetCurrentMenu(menuManager.GetMenuByName("Main Menu"))
	End Method
	
	Method ToString:String()
		Return "Game Manager:" + Super.ToString()
	End Method
	
	Method Update()
		menuManager.Update()
	End Method
	
End Type



