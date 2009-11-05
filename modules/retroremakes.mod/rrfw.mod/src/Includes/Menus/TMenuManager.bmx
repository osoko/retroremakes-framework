
Const CHANNEL_MENU:Int = 10

Type TMenuManager Extends TRenderable

	Field _allMenus:TList
	Field _currentMenu:TMenu
	Field _menuHistory:TStack
		
	Field _menuYpos:Int
	Const DEFAULT_MENU_YPOS:Int = 400
	
	Method New()
		_allMenus = New TList
		_menuHistory = New TStack
		_menuYpos = DEFAULT_MENU_YPOS
		
		rrCreateMessageChannel(CHANNEL_MENU, "Menu Manager")
		
	End Method
	
	Method Start()
	End Method
	
	Method Stop()
	End Method

	Method Update()
	End Method
	
	Method Render(tweening:Double, fixed:Int = False)
		_currentMenu.Render(_menuYpos)
	End Method

	Method SetMenuYpos(y:Int)
		_menuYpos = y
	End Method
	
	Method AddMenu(m:TMenu)
		_allMenus.AddLast(m)
	End Method	
		
	Method AddItemToMenu(m:TMenu, i:TMenuItem)
		i._menu = m
		i._menuManager = Self
		m.AddItem(i)
	End Method	

	Method SetCurrentMenu(m:TMenu)
		_currentMenu = m
	End Method
	
	Method GoToMenu(label:String)
		_menuHistory.Push(_currentMenu)
		_currentMenu = TMenu(GetMenuByName(label))
	End Method
	
'	Method NextMenu()
'		_menuHistory.Push(_currentMenu)
'		_currentMenu = TMenu(
'	End Method
	
	Method PreviousMenu()
		If _menuHistory.Peek() = Null Then Return
		_currentMenu = TMenu(_menuHistory.Pop())
	End Method

	Method NextItem()
		_currentMenu.NextItem()
	End Method
	
	Method PreviousItem()
		_currentMenu.PreviousItem()
	End Method
	
	Method GetCurrentItem:TMenuItem()
		Return _currentMenu.GetCurrentItem()
	End Method
	
	'
	'game manager calls this method to activate the current menu item.
	Method DoItemAction()
		_currentMenu.GetCurrentItem().Activate()
	End Method

	Method GetMenuByName:TMenu(name:String)
		For Local m:TMenu = EachIn _allMenus
			If m.ToString() = name Then Return m
		Next
		Throw "could not find menu:" + name
	End Method
	
	'
	'built-in framework menus
	
	Method BuildGraphicsMenu:TMenu()
	
	End Method
	
	Method BuildAudioMenu:TMenu()
		
	End Method
	
	Method BuildInputMenu:TMenu()
	
	End Method
	
		
rem	
	Method NextOption()
		_currentMenu.NextOption()
	End Method
	
	Method PreviousOption()
		_currentMenu.PreviousOption()
	End Method
endrem	
End Type