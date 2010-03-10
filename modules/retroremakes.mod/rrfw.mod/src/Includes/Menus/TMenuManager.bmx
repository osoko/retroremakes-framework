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
Type TMenuManager

    rem
        bbdoc: default vertical screen position of menus
    endrem
	Const DEFAULT_MENU_YPOS:Int = 300
	
	' The Singleton instance of this class
	Global _instance:TMenuManager

    rem
        bbdocs: list containing all menus in the manager
    endrem
	Field _allMenus:TList
    
    rem
        bbdoc: current active menu
        about: commands send to the menu manager are performed on the current menu
    endrem
	Field _currentMenu:TMenu

	' Default style to use if none have been supplied.
	Field _defaultStyle:TMenuStyle
	
	' Style to use for deselected menu items
	Field _deselectedItemStyle:TMenuStyle
	
	' Style to use for the footers
	Field _footerStyle:TMenuStyle
		
	' Style to use for menu headers
	Field _headerStyle:TMenuStyle
	
    rem
        bbdoc: image font to use when rendering the menus
        about: default font is used if no imagefont is used
    endrem
'	Field _imageFont:TImageFont
		    
    rem
        bbdoc: stack containing menu traversal history
    end rem
	Field _menuHistory:TStack
		
    rem
        bbdoc: vertical screen position of menus
        about: menus are centered horizontally be default
    end rem
	Field _menuYpos:Int
    
	' Style to use for selected menu items
	Field _selectedItemStyle:TMenuStyle

	
		
    rem
        bbdoc: add an item to the menu
        about: item is added at the bottom of the menu
    end rem
	Method AddItemToMenu(menu:TMenu, item:TMenuItem)
		menu.AddItem(item)
	End Method



    rem
        bbdoc: add a new menu to the menu manager
    endrem
	Method AddMenu(m:TMenu)
		_allMenus.AddLast(m)
	End Method


	
'	Method BuildAudioMenu:TMenu()
'	End Method


	
   rem
        bbdoc: build a menu called "Configure Graphics"
        about: this is a built-in menu which handles all needed operations for graphics screen management
        Changed settings are saved by the TGraphicsService
        Projection Matrix (Virtual Resolution) not yet implemented
    end rem
	Function BuildGraphicsMenu:TMenu(hertzFilter:Int = 0, depthFilter:Int = 0)
	
		Local menuManager:TMenuManager = GetInstance()
		
		' Create the actual menu
		Local graphicsMenu:TMenu = New TMenu
		graphicsMenu.SetLabel("Configure Graphics")
		menuManager.AddMenu(graphicsMenu)
		
		'
		' Driver selector
		'
		Local driverSelector:TOptionMenuItem = New TOptionMenuItem
		driverSelector.SetText("Driver", "use left or right to select graphics driver")
		menuManager.AddItemToMenu(graphicsMenu, driverSelector)
		
		Local graphicsService:TGraphicsService = TGraphicsService.GetInstance()
		
		For Local driverName:String = EachIn graphicsService.GetAvailableDrivers()
			Local driver:TMenuOption = New TMenuOption
			driver.SetLabel(driverName)
			driverSelector.AddOption(driver)
		Next

		'
		' Resolution selector
		'
		Local resolutionSelector:TOptionMenuItem = New TOptionMenuItem
		resolutionSelector.SetText("Resolution", "use left or right to select screen resolution")
		menuManager.AddItemToMenu(graphicsMenu, resolutionSelector)

		For Local mode:TGraphicsMode = EachIn graphicsService.GetModes()

			If hertzFilter
				If mode.hertz <> hertzFilter Then Continue
			End If
			
			If depthFilter
				If mode.depth <> depthFilter Then Continue
			End If
			
			'Calculate the aspect ratio of the graphics mode
			Local gcd:Int = GreatestCommonDivisor(mode.width, mode.height)
			Local suffix:String = " (" + mode.width / gcd + ":" + mode.height / gcd + ")"
			
			' 16:10 modes may show up as 8:5 and 16:9 modes may show up as 85:48 when
			' calculated this way, so we'll catch those and modify the suffix accordingly
			If suffix = " (8:5)" Then suffix = " (16:10)"
			If suffix = " (85:48)" Then suffix = " (16:9)"
			
			Local resolution:TMenuOption = New TMenuOption
			
			resolution.SetLabel(mode.width + " x " + mode.height + ", " + mode.hertz + " herz, " + mode.depth + " bit" + suffix)
			resolution.SetOptionObject(mode)
			resolutionSelector.AddOption(resolution)

			'set option to currently set graphics resolution
			If mode.width = graphicsService.GetWidth() And ..
							mode.height = graphicsService.GetHeight() And ..
							mode.hertz = graphicsService.GetRefresh() And ..
							mode.depth = graphicsService.GetDepth()
				
				resolutionSelector.SetCurrentOption(resolution)
			EndIf
		Next
		
		'
		' Windowed/Fullscreen options
		'
		Local windowedSelector:TOptionMenuItem = New TOptionMenuItem
		windowedSelector.SetText("Screen Mode", "use left and right to change screen mode")
		menuManager.AddItemToMenu(graphicsMenu, windowedSelector)
	
		Local windowedOption:TMenuOption = New TMenuOption
		windowedOption.SetLabel("Window")
		windowedSelector.AddOption(windowedOption)
		
		windowedOption = New TMenuOption
		windowedOption.SetLabel("Full Screen")
		windowedSelector.AddOption(windowedOption)
		
		'
		' Vsync on/off
		'		
		Local vsyncSelector:TOptionMenuItem = New TOptionMenuItem
		vsyncSelector.SetText("Vertical Sync", "use left or right to change vertical blank")
		menuManager.AddItemToMenu(graphicsMenu, vsyncSelector)
		
		Local vsyncOption:TMenuOption = New TMenuOption
		vsyncOption.SetLabel("On")
		vsyncSelector.AddOption(vsyncOption)
		vsyncOption = New TMenuOption
		vsyncOption.SetLabel("Off")
		vsyncSelector.AddOption(vsyncOption)
		
		'
		' Apply option
		'
		Local applyAction:TActionMenuItem = New TActionMenuItem
		applyAction.SetText("Apply", "select to apply settings")
		
		'game manager or game screen should listen for this.
		applyAction.SetAction(MENU_ACTION_GRAPHICS_APPLY)
		menuManager.AddItemToMenu(graphicsMenu, applyAction)
		
		'
		' Back option
		'
		Local backMenu:TSubMenuItem = New TSubMenuItem
		backMenu.SetText("Back"), "select to go to previous menu"
		backMenu.SetNextMenu("back")
		menuManager.AddItemToMenu(graphicsMenu, backMenu)
	
		Return graphicsMenu
	
	End Function
	
	
	
'	Method BuildInputMenu:TMenu()
'	End Method


		
    rem
        bbdoc: clear menu traversal history
    endrem
	Method ClearHistory()
		_menuHistory.Clear()
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
		bbdoc: Gets the Singleton instance of this class
	endrem	
	Function GetInstance:TMenuManager()
		If Not _instance
			Return New TMenuManager
		Else
			Return _instance
		EndIf
	End Function
	
	
	
    rem
        bbdoc: returns a menu by passing a name
    endrem
	Method GetMenuByName:TMenu(name:String)
		For Local menu:TMenu = EachIn _allMenus
			If menu.ToString() = name Then Return menu
		Next
		rrThrow "could not find menu:" + name
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
        bbdoc: default constructor
        about: also set defaults and creates a message channel so GameManagers can listen for menu events
    endrem
	Method New()
		If _instance Then rrThrow "Cannot create another instance of this singleton"

		_instance = Self
	
		_allMenus = New TList
		_menuHistory = New TStack
		_menuYpos = DEFAULT_MENU_YPOS
		CreateMessageChannel(CHANNEL_MENU, "Menu Manager")
		
		_defaultStyle = new TMenuStyle
	End Method



    rem
        bbdoc: go to the next item in the current menu
    endrem
	Method NextItem()
		_currentMenu.NextItem()
	End Method

	
 
'	Method NextMenu()
'		_menuHistory.Push(_currentMenu)
'		_currentMenu = TMenu(
'	End Method


	
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
        bbdoc: go to the previous item in the current menu
    endrem	
	Method PreviousItem()
		_currentMenu.PreviousItem()
	End Method

	
		
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
        bbdoc: render the current menu
    endrem	
	Method Render(tweening:Double, fixed:Int = False)
		'SetImageFont _imageFont
		_currentMenu.Render(_menuYpos)
	End Method
    
	
	
	rem
		bbdoc: Set the style to use for selected menu items
	endrem	
	Method SetActiveItemStyle(style:TMenuStyle)
		_selectedItemStyle = style
	End Method
	
	
		
    rem
        bbdoc: set the current active menu
    endrem
	Method SetCurrentMenu(m:TMenu)
		_currentMenu = m
	End Method
	
	

	rem
		bbdoc: Set the style to use for menu footers
	endrem	
	Method SetFooterStyle(style:TMenuStyle)
		_footerStyle = style
	End Method
	
	
	
	rem
		bbdoc: Set the style to use for menu headers
	endrem	
	Method SetHeaderStyle(style:TMenuStyle)
		_headerStyle = style
	End Method
	
	
		
    rem
        bbdoc: set the font to use while drawing menus
    endrem	
	Method SetImageFont(font:TimageFont)
		_defaultStyle.font = font
	End Method

	
	
    rem
        bbdoc: change the vertical position of menus
        about: menus are horizontally centered by default
    endrem
	Method SetMenuYpos(y:Int)
		_menuYpos = y
	End Method
	
	
		
    rem
        bbdoc: Update the current menu
        about: This will also update the current menu item.
    endrem
	Method Update()
		_currentMenu.Update()
	End Method
    


    



    

    

	






    
	
	
 
	

	
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