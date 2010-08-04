Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
bbdoc: Contains all the gui elements and event handling for our application
endrem
Type TEditorGui Extends TAppBase

	'gui elements
	Field splitter:TSplitter
	Field tree_view:TGadget
	Field render_canvas:TGadget
	Field property_grid:TPropertyGrid
	
	'menus
	Field file_menu:TGadget
	Field edit_menu:TGadget
	Field engine_menu:TGadget
	Field options_menu:TGadget
	Field about_menu:TGadget
	
	'checkable menu items
	Field item_autoload:TGadget
	Field item_autosave:TGadget
	Field item_showhelpers:TGadget
	
	'menu item identifiers
	Const MENU_SAVEAS_LIBRARY:Int = 1000
	Const MENU_EXPORT_PROJECT:Int = 1001
	Const MENU_EXIT:Int = 1002
	Const MENU_ADD_IMAGE:Int = 1003
	Const MENU_ADD_PARTICLE:Int = 1004
	Const MENU_ADD_EMITTER:Int = 1005
	Const MENU_ADD_EFFECT:Int = 1006
	Const MENU_ADD_PROJECT:Int = 1007
	Const MENU_DELETE_OBJECT:Int = 1008
	Const MENU_CLONE_OBJECT:Int = 1009
	Const MENU_AUTOLOAD:Int = 1010
	Const MENU_AUTOSAVE:Int = 1011
	Const MENU_SPAWN_SELECTION:Int = 1012
	Const MENU_TOGGLE_ENGINE:Int = 1013
	Const MENU_CLEAR_ENGINE:Int = 1014
	Const MENU_SHOWHELPERS:Int = 1015
	Const MENU_ABOUT:Int = 1016
	Const MENU_NEW_LIBRARY:Int = 1017
	Const MENU_OPEN_LIBRARY:Int = 1018
	Const MENU_SAVE_LIBRARY:Int = 1019
	
	'direct links to treeview main items
	Field imageRoot:TGadget
	Field particleRoot:TGadget
	Field emitterRoot:TGadget
	Field effectRoot:TGadget
	Field projectRoot:TGadget
	
	
	'misc	
	Const PROPERTY_GRID_WIDTH:Int = 300
	Const APP_NAME:String = "ParticlesMAX RRFW Edition - "
	
	
	rem
	bbdoc: Default Constructor
	endrem	
	Method New()
		SetUpForm()
		SetupTree()
		SetUpMenus()
		SetUpEvents()
	End Method

	

	rem
	bbdoc: Sets up the GUI form
	endrem	
	Method SetUpForm()
		Local tmpSplitPanel:TGadget
	
		main_window = CreateWindow(APP_NAME, 0, 0, 800, 800, Null,  ..
			WINDOW_TITLEBAR | WINDOW_MENU | WINDOW_RESIZABLE | WINDOW_CENTER | WINDOW_STATUS)
		SetMinWindowSize(main_window, 800, 800)
		
		splitter = CreateSplitter(0, 0, ClientWidth(main_window) - PROPERTY_GRID_WIDTH, ClientHeight(main_window), main_window)
		SetSplitterPosition(splitter, 300)
		SetGadgetLayout(splitter, EDGE_ALIGNED, EDGE_CENTERED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		tmpSplitPanel = SplitterPanel(splitter, SPLITPANEL_MAIN)
		tree_view = CreateTreeView(0, 0, ClientWidth(tmpSplitPanel), ClientHeight(tmpSplitPanel), tmpSplitPanel)
		SetGadgetLayout(tree_view, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
				
		tmpSplitPanel = SplitterPanel(splitter, SPLITPANEL_SIDEPANE)
		render_canvas = CreateCanvas(0, 0, ClientWidth(tmpSplitPanel), ClientHeight(tmpSplitPanel), tmpSplitPanel)
		SetGadgetLayout(render_canvas, EDGE_ALIGNED, EDGE_CENTERED, EDGE_ALIGNED, EDGE_ALIGNED)

		property_grid = TPropertyGrid.GetInstance()
		PROPERTY_GRID.Initialize(ClientWidth(main_window) - PROPERTY_GRID_WIDTH, 0, PROPERTY_GRID_WIDTH, ClientHeight(main_window), main_window)
		
		'test
		Local group:TPropertyGroup = CreatePropertyGroup("Image", property_grid)
		CreatePropertyItemString("String", "Hoi!", group)
		
	End Method
	
	
	
	rem
	bbdoc: Sets up the menus
	endrem	
	Method SetUpMenus()
		file_menu = CreateMenu("File", 0, WindowMenu(main_window))
		edit_menu = CreateMenu("Edit", 1, WindowMenu(main_window))
		engine_menu = CreateMenu("Engine", 2, WindowMenu(main_window))
		options_menu = CreateMenu("Options", 3, WindowMenu(main_window))
		about_menu = CreateMenu("About", 3, WindowMenu(main_window))
		
		'file
		CreateMenu("New Library", MENU_NEW_LIBRARY, file_menu, KEY_N, MODIFIER_COMMAND)
		CreateMenu("Open Library...", MENU_OPEN_LIBRARY, file_menu, KEY_O, MODIFIER_COMMAND)
		CreateMenu("", 0, file_menu)
		CreateMenu("Save Library", MENU_SAVE_LIBRARY, file_menu, KEY_S, MODIFIER_COMMAND)
		CreateMenu("Save Library As...", MENU_SAVEAS_LIBRARY, file_menu, KEY_S, MODIFIER_COMMAND | MODIFIER_SHIFT)
		CreateMenu("", 0, file_menu)
		CreateMenu("Export Project...", MENU_EXPORT_PROJECT, file_menu, KEY_E, MODIFIER_COMMAND)
		CreateMenu("", 0, file_menu)
		CreateMenu("Exit", MENU_EXIT, file_menu, KEY_F4, MODIFIER_OPTION)
		
		'edit
		CreateMenu("Add Image", MENU_ADD_IMAGE, edit_menu)
		CreateMenu("Add Particle", MENU_ADD_PARTICLE, edit_menu)
		CreateMenu("Add Emitter", MENU_ADD_EMITTER, edit_menu)
		CreateMenu("Add Effect", MENU_ADD_EFFECT, edit_menu)
		CreateMenu("Add Project", MENU_ADD_PROJECT, edit_menu)
		CreateMenu("", 0, edit_menu)
		CreateMenu("Delete Selection", MENU_DELETE_OBJECT, edit_menu, KEY_DELETE, MODIFIER_COMMAND)
		CreateMenu("Clone Selection", MENU_CLONE_OBJECT, edit_menu, KEY_C, MODIFIER_COMMAND)
		
		'engine
		CreateMenu("Spawn Selection", MENU_SPAWN_SELECTION, engine_menu, KEY_F5)
		CreateMenu("Toggle Engine", MENU_TOGGLE_ENGINE, engine_menu, KEY_F8)
		CreateMenu("Clear", MENU_CLEAR_ENGINE, engine_menu, KEY_F6)
		CreateMenu("", 0, engine_menu)
		item_showhelpers = CreateMenu("Show Helpers", MENU_SHOWHELPERS, engine_menu, KEY_H, MODIFIER_COMMAND)
		
		'options
		item_autoload = CreateMenu("Load Library On Startup", MENU_AUTOLOAD, options_menu)
		item_autosave = CreateMenu("Save Library on Exit", MENU_AUTOSAVE, options_menu)

		'about
		CreateMenu("About...", MENU_ABOUT, about_menu, KEY_F1)
		
		UpdateWindowMenu(main_window)
	End Method
	
	
	
	rem
	bbdoc: Sets up custom gui events
	endrem	
	Method SetUpEvents()
		
	End Method

	
	
	rem
	bbdoc: Sets up tree main items
	endrem	
	Method SetupTree()
		imageRoot = AddTreeViewNode("Images", TreeViewRoot(tree_view))
		particleRoot = AddTreeViewNode("Particles", TreeViewRoot(tree_view))
		emitterRoot = AddTreeViewNode("Emitters", TreeViewRoot(tree_view))
		effectRoot = AddTreeViewNode("Effects", TreeViewRoot(tree_view))
		projectRoot = AddTreeViewNode("Projects", TreeViewRoot(tree_view))
	End Method
	

	
	Rem
	bbdoc: Processes menu actions and calls On... methods
	about: On.. methods are located in the TEditorMain type.
	endrem	
	Method OnMenuAction()
		Select EventData()
			Case MENU_NEW_LIBRARY

			Case MENU_OPEN_LIBRARY

			Case MENU_SAVE_LIBRARY

			Case MENU_SAVEAS_LIBRARY

			Case MENU_EXPORT_PROJECT

			Case MENU_EXIT
				OnMenuExit()
			Case MENU_ADD_IMAGE

			Case MENU_ADD_PARTICLE

			Case MENU_ADD_EMITTER

			Case MENU_ADD_EFFECT

			Case MENU_ADD_PROJECT

			Case MENU_DELETE_OBJECT

			Case MENU_CLONE_OBJECT

			Case MENU_AUTOLOAD
				OnChangeAutoLoad()
			Case MENU_AUTOSAVE
				OnChangeAutoSave()
			Case MENU_SPAWN_SELECTION

			Case MENU_TOGGLE_ENGINE

			Case MENU_CLEAR_ENGINE

			Case MENU_SHOWHELPERS
 				OnChangeShowHelpers()
			Case MENU_ABOUT
				OnAbout()

		End Select
	End Method
	
	'---------------------------------------------------------------------
	'the following methods are over ridden in TEditorMain
	
	Method OnMenuExit()
		DebugLog "Override me!!"
	End Method

	Method OnChangeAutoLoad()
		DebugLog "Override me!!"
	End Method

	Method OnChangeAutoSave()
		DebugLog "Override me!!"
	End Method

	Method OnChangeShowHelpers()
		DebugLog "Override me!!"
	End Method

	Method OnAbout()
		DebugLog "Override me!!"
	End Method

End Type


