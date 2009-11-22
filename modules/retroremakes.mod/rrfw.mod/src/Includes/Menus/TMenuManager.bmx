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

rem
	bbdoc: Manager for game menus
endrem
Type TMenuManager Extends TRenderable

    rem
        bbdocs: list containing all menus in the manager
    endrem
	Field _allMenus:TList
    
    rem
        bbdoc: current active menu
        about: commands send to the menu manager are performed on the current menu
    endrem
	Field _currentMenu:TMenu
    
    rem
        bbdoc: stack containing menu traversal history
    end rem
	Field _menuHistory:TStack
    
    rem
        bbdoc: image font to use when rendering the menus
        about: default font is used if no imagefont is used
    endrem
	Field _imageFont:TImageFont
		
    rem
        bbdoc: vertical screen position of menus
        about: menus are centered horizontally be default
    end rem
	Field _menuYpos:Int
    
    rem
        bbdoc: default vertical screen position of menus
    endrem
	Const DEFAULT_MENU_YPOS:Int = 300
	
    rem
        bbdoc: defaiult constructor
        about: set defaults and creates a message channel so GameManagers can listen for menu events
    endrem
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

    rem
        bbdoc: Update the current menu
        about: This will also update the current menu item.
    endrem
	Method Update()
		_currentMenu.Update()
	End Method
    
    rem
        bbdoc: render the current menu
    endrem	
	Method Render(tweening:Double, fixed:Int = False)
		SetImageFont _imageFont
		_currentMenu.Render(_menuYpos)
	End Method
    
    rem
        bbdoc: set the font to use while drawing menus
    endrem	
	Method SetImageFont(font:TimageFont)
		_imagefont = font
	End Method

    rem
        bbdoc: change the vertical position of menus
        about: menus are horizontally centered by default
    endrem
	Method SetMenuYpos(y:Int)
		_menuYpos = y
	End Method
	
    rem
        bbdoc: add a new menu to the menu manager
    endrem
	Method AddMenu(m:TMenu)
		_allMenus.AddLast(m)
	End Method	
    
    rem
        bbdoc: add an item to the menu
        about: item is added at the bottom of the menu
    end rem
	Method AddItemToMenu(m:TMenu, i:TMenuItem)
		i._menu = m
		i._menuManager = Self
		m.AddItem(i)
	End Method	

    rem
        bbdoc: set the current active menu
    endrem
	Method SetCurrentMenu(m:TMenu)
		_currentMenu = m
	End Method
    
    rem
        bbdoc: Go to the requested menu
        about: Menu is found using the title of the menu
        Current menu is pushed to the history stack
        Built-in menus are synced to the service they are reflecting
    endrem        
	Method GoToMenu(label:String)
		_menuHistory.Push(_currentMenu)
		_currentMenu = TMenu(GetMenuByName(label))
		_currentMenu.FirstItem()
		
		'check to see if a built-in menu is accessed and sync it to the currently active settings
		Select label
			Case "Configure Graphics"
				Self.SyncGraphicsMenu()
		End Select
		
		'check items to see if it contains an option which has a default setting in the gamesettings ini file.
		Local items:TList = _currentMenu.GetItems()
		For Local i:TMenuItem = EachIn items
			If TOptionMenuItem(i) Then TOptionMenuItem(i).SyncToDefaultOption()
		Next
		
	End Method
    
    rem
        bbdoc: clear menu traversal history
    endrem
	Method ClearHistory()
		_menuHistory.Clear()
	End Method
	
'	Method NextMenu()
'		_menuHistory.Push(_currentMenu)
'		_currentMenu = TMenu(
'	End Method

    rem
        bbdoc: go to the previous menu
        about: afterwards, focus is placed on the first item in the menu
    endrem	
	Method PreviousMenu()
		If _menuHistory.Peek() = Null Then Return
		_currentMenu = TMenu(_menuHistory.Pop())
		_currentMenu.FirstItem()
	End Method

    rem
        bbdoc: go to the next item in the current menu
    endrem
	Method NextItem()
		_currentMenu.NextItem()
	End Method

    rem
        bbdoc: go to the previous item in the current menu
    endrem	
	Method PreviousItem()
		_currentMenu.PreviousItem()
	End Method
	
    rem
        bbdoc: return the current item in the current menu
    endrem    
	Method GetCurrentItem:TMenuItem()
		Return _currentMenu.GetCurrentItem()
	End Method
    
    rem
        bbdoc: select the next option on the current item
        about: only works when the current item is a #TOptionMenuItem
    endrem
	Method NextOption:Int()
		If TOptionMenuItem(_currentMenu.GetCurrentItem())
			_currentMenu.NextOption()
			Return True
		EndIf
		Return False
	End Method

	rem
        bbdoc: select the previous option on the current item
        about: only works when the current item is a #TOptionMenuItem
    endrem
	Method PreviousOption:Int()
		If TOptionMenuItem(_currentMenu.GetCurrentItem())
			_currentMenu.PreviousOption()
			Return True
		EndIf
		Return False
	End Method

    rem
        bbdoc: returns a menu by passing a name
    endrem
	Method GetMenuByName:TMenu(name:String)
		For Local m:TMenu = EachIn _allMenus
			If m.ToString() = name Then Return m
		Next
		Throw "could not find menu:" + name
	End Method
    
    rem
        bbdoc: activates the current menu item
        about: runs the Activate() method in the current item. Only works
        if the item is a #TActionMenuItem
    endrem    
	Method DoItemAction()
		_currentMenu.GetCurrentItem().Activate()
	End Method	
	
    rem
        bbdoc: build a menu called "Configure Graphics"
        about: this is a built-in menu which handles all needed operations for graphics screen management
        Changed settings are saved by the TGraphicsService
        Projection Matrix (Virtual Resolution) not yet implemented
    end rem
	Method BuildGraphicsMenu:TMenu(hertzFilter:Int = 0, depthFilter:Int = 0)
	
		Local m:TMenu
		Local i:TOptionMenuItem
		Local o:TMenuOption
		
		m = New TMenu
		m.SetLabel("Configure Graphics")
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
			
			' 16:10 modes may show up as 8:5 when calculated this way, so we'll
			' catch those and modify the suffix accordingly
			If suffix = " (8:5)" Then suffix = " (16:10)"
			If suffix = " (85:48)" Then suffix = " (16:9)"
			
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
Rem		
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
	
'	Method BuildAudioMenu:TMenu()
'	End Method
	
'	Method BuildInputMenu:TMenu()
'	End Method
	
	rem
        bbdoc: Apply the settings as defined in the built-in "Configure Graphics" menu to the TGraphicsService
        about: settings are saved automatically by TGraphicsService
    endrem
	Method ApplyGraphicsMenu()
	
		Local m:TMenu = GetMenuByName("Configure Graphics")
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
Rem					
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
		g.Set()
	
	End Method
	
    rem
        bbdoc: Sync the built-in "Configure Graphics" menu to TGrahpicsDriver settings
        about: This ensures that the menu reflects the current settings in TGraphicsDriver
        Method is run when the menumanager is entering a built-in menu using GoToMenu()
    endrem
	Method SyncGraphicsMenu()
		Local m:TMenu = GetMenuByName("Configure Graphics")
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