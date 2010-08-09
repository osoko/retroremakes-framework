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
bbdoc: Contains gui elements and event handling for our application
endrem
Type TEditorGui Extends TAppBase

	'gui elements
	Field splitter:TSplitter
	Field tree_view:TGadget
	Field render_canvas:TGadget
	Field property_grid:TPropertyGrid
	
	'property groups
	Field image_group:TPropertyGroup
	Field particle_group:TPropertyGroup
	Field emitter_group:TPropertyGroup
	Field effect_group:TPropertyGroup
	Field project_group:TPropertyGroup
	
	'treeview main nodes
	Field image_root:TGadget
	Field particle_root:TGadget
	Field emitter_root:TGadget
	Field effect_root:TGadget
	Field project_root:TGadget	
	
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

	
	'misc	
	Const PROPERTY_GRID_WIDTH:Int = 300
	Const APP_NAME:String = "ParticlesMAX RRFW Edition"
	
	
	rem
	bbdoc: Default Constructor
	endrem	
	Method New()
		SetUpForm()
		SetupTree()
		SetupPropertyGroups()
		SetUpMenus()
		SetUpEvents()
	End Method
	
	
	
	rem
		bbdoc: Main event loop
		about: The methods are present in this type, but overridden in the main app type
	endrem
	Method Run()
		Repeat
			WaitEvent()
			
			'debug stuff
			Print CurrentEvent.ToString()
			
			Select EventID()
				Case EVENT_WINDOWCLOSE, EVENT_APPTERMINATE
					OnMenuExit()
				Case EVENT_MENUACTION
					OnMenuAction()
				Case EVENT_GADGETACTION
					OnGadgetAction()
				Case EVENT_GADGETSELECT
					OnGadgetSelect()
				Case EVENT_MOUSEDOWN
					OnMouseDown()
				Case EVENT_ITEMCHANGED
					OnItemChange(TPropertyItem(EventSource()))
				
				Default
					
			End Select
		Forever
	End Method

		

	rem
	bbdoc: Sets up the GUI form
	endrem	
	Method SetUpForm()
		Local tmpSplitPanel:TGadget
	
		main_window = CreateWindow(APP_NAME, 0, 0, 800, 800, Null,  ..
			WINDOW_TITLEBAR | WINDOW_MENU | WINDOW_RESIZABLE | WINDOW_CENTER | WINDOW_STATUS)
		SetMinWindowSize(main_window, 800, 400)
		
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
	bbdoc: Sets up treeview items
	endrem	
	Method SetupTree()
		image_root = AddTreeViewNode("Images", TreeViewRoot(tree_view))
		particle_root = AddTreeViewNode("Particles", TreeViewRoot(tree_view))
		emitter_root = AddTreeViewNode("Emitters", TreeViewRoot(tree_view))
		effect_root = AddTreeViewNode("Effects", TreeViewRoot(tree_view))
		project_root = AddTreeViewNode("Projects", TreeViewRoot(tree_view))
	End Method
	

	
	Rem
	bbdoc: Creates the property groups for each item type
	about: Groups are created hidden.
	endrem
	Method SetupPropertyGroups()
	
		image_group = CreatePropertyGroup("Image", property_grid)
		property_grid.HideGroup(image_group)
		particle_group = CreatePropertyGroup("Particle", property_grid)
		property_grid.HideGroup(particle_group)
		
		New TEditorImage.SetupGroupItems(image_group)
		

		'particle
'		CreatePropertyItemString("Name", "", particle_group)
'		CreatePropertyItemString("Description", "", particle_group)

'		emitter_group = CreatePropertyGroup("Emitter", property_grid, False)
'		CreatePropertyItemString("Name", "", emitter_group)
'		CreatePropertyItemString("Description", "", emitter_group)
'		CreatePropertyItemChoice("Appearance", emitter_group)
'		choice = CreatePropertyItemChoice("Shape", emitter_group)
'		choice.AddItem("Radial")
'		choice.AddItem("Fountain")
'		choice.AddItem("Line")
'		CreatePropertyItemInt("Life", -1, emitter_group)
'		CreatePropertyItemBool("Sticky", False, emitter_group)
'		CreatePropertyItemInt("X offset", 0, emitter_group)
'		CreatePropertyItemInt("Y offset", 0, emitter_group)
'		
'		CreateValueSubGroup("Angle", emitter_group)
'		CreateValueSubGroup("Size X", emitter_group)
'		CreateValueSubGroup("Size Y", emitter_group)
		
		
		'CreatePropertyItemString("String", "Hoi!", group)
		'CreatePropertyItemInt("Integer", 50, group)
		'CreatePropertyItemFloat("Float", 2.01, group)
		'CreatePropertyItemColor("Color", 255, 255, 0, group)
		'CreatePropertyItemBool("Bool", False, group)
		

		'Local choice:TPropertyItemChoice = CreatePropertyItemChoice("Choice", group)
		'choice.AddItem("A")
		'choice.AddItem("B")
		'choice.AddItem("C")
		
	End Method
	
	
	
	rem
	bbdoc: Creates items for editable values in a group
	endrem
	Method CreateValueGroup:TPropertyGroup(name:String, parent:TPropertyGroup)
		Local choice:TPropertyItemChoice
		Local sub_group:TPropertyGroup = CreatePropertyGroup(name, parent)
			
		CreatePropertyItemFloat("Start Value", 1.0, 0, sub_group)
		CreatePropertyItemFloat("End Value", 1.0, 0, sub_group)
		CreatePropertyItemBool("Change over time", False, 0, sub_group)
		choice = CreatePropertyItemChoice("Behaviour", 0, sub_group)
		choice.AddItem("Once")
		choice.AddItem("Repeat")
		choice.AddItem("PingPong")
		CreatePropertyItemInt("Start Delay", 0, 0, sub_group)
		CreatePropertyItemFloat("Change Amount", 0.1, 0, sub_group)
		
		Return sub_group
	
	End Method

	
	
	rem
	bbdoc:
	endrem
	Method OnGadgetAction()
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
				OnAddImage()

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
	'the following methods are overridden in TEditorMain
	
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

	Method OnAddImage()
		DebugLog "Override me!!"
	End Method
		
	Method OnMouseDown()
		DebugLog "Override me!!"
	End Method
	
	Method OnItemChange(i:TPropertyItem)
		DebugLog "Override me!!"
	End Method
	
	Method OnGadgetSelect()
		DebugLog "Override me!!"
	End Method
	
End Type


