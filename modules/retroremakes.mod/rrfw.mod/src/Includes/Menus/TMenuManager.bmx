

Type TMenuManager Extends TRenderable

	Field _allMenus:TList
	Field _currentMenu:TMenu
	Field _menuHistory:TStack
		
	Field _menuYpos:Int
	Const DEFAULT_MENU_YPOS:Int = 300
	
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
		
		'check to see if a built-in menu is accessed and sync it to the currently active settings
		Select label
			Case "Graphics"
				Self.SyncGraphicsMenu()
		End Select
		
	End Method

	Method ClearHistory()
		_menuHistory.Clear()
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
	

	Method NextOption()
		_currentMenu.NextOption()
	End Method
	
	Method PreviousOption()
		_currentMenu.PreviousOption()
	End Method

	Method GetMenuByName:TMenu(name:String)
		For Local m:TMenu = EachIn _allMenus
			If m.ToString() = name Then Return m
		Next
		Throw "could not find menu:" + name
	End Method

	'
	'game manager calls this method to activate the current menu item.
	Method DoItemAction()
		_currentMenu.GetCurrentItem().Activate()
	End Method	
		
	'
	'built-in framework menus
	
	Method BuildGraphicsMenu:TMenu(hertzFilter:Int = 0, depthFilter:Int = 0)
	
		Local m:TMenu
		Local i:TOptionMenuItem
		Local o:TMenuOption
		
		m = New TMenu
		m.SetLabel("Graphics")
		AddMenu(m)
		
		i = New TOptionMenuItem
		i.SetText("Driver", "use left or right to select graphics driver")
		addItemToMenu(m, i)
		
		Local g:TGraphicsService = TGraphicsService.GetInstance()
		
		For Local driverName:String = EachIn g.GetAvailableDrivers()
			o = New TMenuOption
			o.SetLabel(driverName)
			i.AddOption(o)
		Next
rem		
		?Win32
			o = New TMenuOption
			o.SetLabel("DirectX7")
			i.AddOption(o)
			o = New TMenuOption
			o.SetLabel("DirectX9")
			i.AddOption(o)
		?

		o = New TMenuOption
		o.SetLabel("OpenGL")
		i.AddOption(o)
endrem		
		i = New TOptionMenuItem
		i.SetText("Resolution", "use left or right to select screen resolution")
		AddItemToMenu(m, i)
		

		Local suffix:String
		For Local mode:TGraphicsMode = EachIn g.GetModes()
			o = New TMenuOption
			
			If hertzFilter
				If mode.hertz <> hertzFilter Then Continue
			End If
			
			If depthFilter
				If mode.depth <> depthFilter Then Continue
			End If
			
			'Calculate the aspect ration of the graphics mode
			Local gcd:Int = rrGreatestCommonDivisor(mode.width, mode.height)
			suffix = " (" + mode.width / gcd + ":" + mode.height / gcd + ")"
			'If Int((mode.height / 10) * 16) = mode.width Then suffix = " (wide 16:10)"
			'If Int((mode.height / 9) * 16) = mode.width Then suffix = " (wide 16:9)"
			'If Int((mode.height / 4) * 5) = mode.width Then suffix = " (wide 5:4)"
			
			o.SetLabel(mode.width + " x " + mode.height + ", " + mode.hertz + " herz, " + mode.depth + " bit" + suffix)
			o.SetOptionObject(mode)
			i.AddOption(o)

			'set option to currently set graphics resolution
			If mode.width = g.GetWidth() And mode.height = g.GetHeight() And mode.hertz = g.GetRefresh() And mode.depth = g.GetDepth()
				i.SetCurrentOption(o)
			EndIf
		Next
		
		i = New TOptionMenuItem
		i.SetText("Screen Mode", "use left and right to change screen mode")
		AddItemToMenu(m, i)
		o = New TMenuOption
		o.SetLabel("Window")
		i.AddOption(o)
		o = New TMenuOption
		o.SetLabel("Full Screen")
		i.AddOption(o)
				
		i = New TOptionMenuItem
		i.SetText("Vertical Sync", "use left or right to change vertical blank")
		AddItemToMenu(m, i)
		o = New TMenuOption
		o.SetLabel("On")
		i.AddOption(o)
		o = New TMenuOption
		o.SetLabel("Off")
		i.AddOption(o)
rem		
		If rrProjectionMatrixEnabled()
			i = New TOptionMenuItem
			i.SetText("Aspect Ratio", "use left or right to change screen aspect")
			m.AddItem(i)
			o = New TMenuOption
			o.SetLabel("Normal (4:3)")
			i.AddOption(o)
			o = New TMenuOption
			o.SetLabel("Widescreen (16:9)")
			i.AddOption(o)
			o = New TMenuOption
			o.SetLabel("Widescreen (16:10)")
			i.AddOption(o)
		EndIf
endrem		
		Local a:TActionMenuItem = New TActionMenuItem
		a.SetText("Apply", "select to apply settings")
		a.SetAction(MENU_ACTION_GRAPHICS_APPLY)							'game manager or game screen should listen for this.
		AddItemToMenu(m, a)
		
		Local s:TSubMenuItem = New TSubMenuItem
		s.SetText("Back"), "select to go to previous menu"
		s.SetNextMenu("back")
		AddItemToMenu(m, s)
	
		Return m
	
	End Method
	
	Method BuildAudioMenu:TMenu()
	End Method
	
	Method BuildInputMenu:TMenu()
	End Method
	
	'
	'apply methods, for built-in menus
	
	Method ApplyGraphicsMenu()
	
		Local m:TMenu = GetMenuByName("Graphics")
		Local list:TList = m.GetItems()
		Local option:TMenuOption
		Local g:TGraphicsService = TGraphicsService.GetInstance()
		
		
		'
		'walk past all menu items, read and set
		'using the internal graphics service methods ensures the settings get added to the config vaiables as well.
		
		For Local o:TOptionMenuItem = EachIn list
			Select o.GetLabel()
				Case "Driver"
					option = o.GetCurrentOption()
					g.SetDriver(option.ToString())
			
				Case "Resolution"
					option = o.GetCurrentOption()
					Local mode:TGraphicsMode = TGraphicsMode(option.GetOptionObject())
					g.SetWidth(mode.width)
					g.SetHeight(mode.height)
					g.SetRefresh(mode.hertz)
					g.SetDepth(mode.depth)

				Case "Screen Mode"
					option = o.GetCurrentOption()
					Select option.ToString()
						Case "Window"
							g.SetWindowed(True)
						Case "Full Screen"
							g.SetWindowed(False)
					End Select
					
				Case "Vertical Sync"
					option = o.GetCurrentOption()
					Select option.ToString()
						Case "On"
							g.SetVBlank(True)
						Case "Off"
							g.SetVBlank(False)
					End Select
rem					
				Case "Aspect Ratio"
					option = o.GetCurrentOption()
					Local p:TProjectionMatrix = TProjectionMatrix.GetInstance()
					Select option.ToString()
						Case "Normal (4:3)"
							p.EnableNormalScreenAspect()					'these must have been set earlier.  make defaults in pmatrix??
						Case "Widescreen (16:9)"
							p.EnableWideScreenAspect()
						Case "Widescreen (16:10)"
							p.EnableWideScreenAspect()
					End Select
endrem				
			End Select
		Next
		
		'apply
'		If rrProjectionMatrixEnabled() Then TProjectionMatrix.GetInstance().Set()
		g.Set()
		
	End Method
	
	
	'
	'sync menu methods
	
	'these methods sync the build in menus to the settings currently in the config variables. this ensures that the menu settings reflect
	'the current configuration. these methods are run when the menumanager is entering a built-in menu
	
	Method SyncGraphicsMenu()
		Local m:TMenu = GetMenuByName("Graphics")
		Local list:TList = m.GetItems()
		Local g:TGraphicsService = TGraphicsService.GetInstance()

		For Local item:TOptionMenuItem = EachIn list
			Select item.GetLabel()
			
				Case "Driver"
					Local Driver:String = g.GetDriver()
					Select Driver.ToLower()
						Case "directx7"
							item.SetCurrentOptionByName("DirectX7")
						Case "directx9"
							item.SetCurrentOptionByName("DirectX9")
						Case "opengl"
							item.SetCurrentOptionByName("OpenGL")
					End Select
			
				Case "Resolution"
					'
					'walk through options and find the match with current settings in the graphics service.
					Local optionsList:TList = item.GetOptions()
					For Local option:TMenuOption = EachIn optionsList
						Local mode:TGraphicsMode = TGraphicsMode(option.GetOptionObject())
						If mode.width = g._width And mode.height = g._height And mode.hertz = g._refresh And mode.depth = g._depth
							item.SetCurrentOption(option)
							Exit
						End If
					Next
					
				Case "Screen Mode"
					If g.GetWindowed()
						item.SetCurrentOptionByName("Window")
					Else
						item.SetCurrentOptionByName("Full Screen")
					End If
					
				Case "Vertical Sync"
					If g.GetVBlank()
						item.SetCurrentOptionByName("On")
					Else
						item.SetCurrentOptionByName("Off")
					End If
			End Select
		Next
	End Method

End Type