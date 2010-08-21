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

rem
bbdoc: Main application logic
endrem
Type TEditorMain Extends TEditorGui

	'ini file handler
	Field configFile:TINIFile
	
	'currently selected object
	Field selection:Object
	
	'currently selected tree item
	Field selectedTreeItem:TGadget
	
	'last dragged object
	Field draggedItem:Object

	'true when item added/changed. false when library is saved.	
	Field changed:Int
	
	Field library:TEditorLibrary
	
	'Field engineTimer:?
	
	
			
	rem
		bbdoc: Default Constructor
	endrem
	Method New()
		 Init()
	End Method
	
	
	
	Method Init()
		ReadConfiguration()
		SyncMenusToConfiguration()
		SetLayout()
		SetupLibrary()
		
		If configFile.GetBoolValue("Library", "AutoLoad") = True Then ..
			LoadLibrary(configFile.GetStringValue("Library", "LibraryName"))
	End Method
	
	
	
	Method SetupLibrary()
		library = New TEditorLibrary
		library.SetReader(New TParticleLibraryReader)	'located in the rrfw particles mod
		library.SetWriter(New TParticleLibraryWriter)	'custom for this editor
	End Method
	

		
	Method LoadLibrary(filename:String)
		library.ReadConfiguration(filename)
	End Method
	


	Method SaveLibrary(filename:String)
		library.writeconfiguration(filename)
	End Method
	
	
	
	rem
		bbdoc: Loads editor configuration file
		about: Creates default settings if ini file cannot be loaded
	endrem
	Method ReadConfiguration()
		configFile = TINIFile.Create("editorconfig.ini")
		
		If Not configFile.Load()
			configFile.CreateMissingEntries(True)
			configFile.AddSection("Layout")
			configFile.SetIntValue("Layout", "Xposition", 50)
			configFile.SetIntValue("Layout", "Yposition", 50)
			configFile.SetIntValue("Layout", "Width", 800)
			configFile.SetIntValue("Layout", "Height", 800)
			configFile.SetIntValue("Layout", "Splitter", 600)
			Local array:Int[3]
			array[0] = 50
			array[1] = 50
			array[2] = 50
			configFile.SetIntValues("Layout", "BackdropColor", array)
			configFile.SetBoolValue("Layout", "ShowHelpers", "false")
					
			configFile.AddSection("Library")
			configFile.SetBoolValue("Library", "AutoSave", "true")
			configFile.SetBoolValue("Library", "AutoLoad", "false")
			configFile.SetStringValue("Library", "LibraryName", "")
		EndIf
		
	End Method	
	
	
	
	rem
		bbdoc: Sets menu flags according to settings in config file
	endrem
	Method SyncMenusToConfiguration()
		If configFile.GetBoolValue("Library", "AutoLoad") = True Then CheckMenu(item_autoload)
		If configFile.GetBoolValue("Library", "AutoSave") = True Then CheckMenu(item_autosave)
		If configFile.GetBoolValue("Layout", "ShowHelpers") = True Then CheckMenu(item_showhelpers)
	End Method
	
	
	
	rem
	bbdoc: Sets the application layout as configured in the config file
	endrem
	Method SetLayout()
		SetPosition(configFile.GetIntValue("Layout", "Xposition"), configFile.GetIntValue("Layout", "Yposition"))
		SetSize(configFile.GetIntValue("Layout", "Width"), configFile.GetIntValue("Layout", "Height"))
		SetSplitterPosition(splitter, configFile.GetIntValue("Layout", "Splitter"))
	End Method
	
	
	
	rem
	bbdoc: Sets render canvas background color
	endrem
	Method SetBGcolor()
		Local array:Int[] = configFile.GetIntValues("Layout", "BackdropColor")
		SetGraphics(CanvasGraphics(render_canvas))
		SetClsColor(array[0], array[1], array[2])
	End Method
	
	
	
	rem
	bbdoc: Populates tree view with items from the loaded library
	endrem
	Method PopulateTree()
		
		ClearTree()
		
		'fill tree
		
		
		'show all
		ExpandTreeViewNode(TreeViewRoot(tree_view))
	End Method
	
	
	
	rem
	bbdoc: Clears all items in the tree control
	endrem
	Method ClearTree()
'		RemoveGadgetItem()
'		LIBRARY_TREE.DeleteChildren(_imageRoot)
'		LIBRARY_TREE.DeleteChildren(_particleRoot)
'		LIBRARY_TREE.DeleteChildren(_effectRoot)
'		LIBRARY_TREE.DeleteChildren(_emitterRoot)
'		LIBRARY_TREE.DeleteChildren(_projectRoot)
	End Method	
	

	
	rem
	bbdoc: Clean up, and end the editor
	endrem	
	Method CloseEditor()
		If configFile.GetBoolValue("Library", "AutoSave") = True Then SaveLibrary("")
		configFile.Save()
		
		'stop timers, etc
		
		End
	End Method	
		
	
	
	rem
	bbdoc: Sets window title to reflect loaded library
	endrem
	Method SetWindowTitle()
		Local title:String = "" + APP_NAME + " - " + StripDir(configFile.GetStringValue("Library", "LibraryName"))
		If changed Then title:+"*"
		SetGadgetText(main_window, title)
	End Method

	
	
	rem
	bbdoc: Determines the selected treeview gadget and refreshes the propertygrid
	about: Called when user selects a treeview gadget
	endrem
	Method OnGadgetSelect()
	
		Local node:TGadget = SelectedTreeViewNode(tree_view)
		Local extra:Object = GadgetExtra(node)
		
		If TEditorImage(extra) Then OnSelectImage(TEditorImage(extra)) ;Return
		'etc

	End Method
	
	
	
	Method OnSelectImage(i:TEditorImage)
		selection = i
		i.SetPropertyGroupItems()
		property_grid.ShowGroup(image_group)
		property_grid.HideGroup(particle_group)
'		property_grid.HideGroup(emitter_group)
'		property_grid.HideGroup(effect_group)
'		property_grid.HideGroup(project_group)
	End Method		

	
	
	rem
	bbdoc:
	about: Called when user changes an item in the property grid
	endrem
	Method OnItemChange(i:TPropertyItem)
	
		If TEditorImage(selection) Then TEditorImage(selection).ChangeSetting(i) ;Return
		
		'etc		
		
	End Method
	
	
	
	rem
	bbdoc: Adds a new image to the library
	endrem
	Method OnAddImage()
		Local i:TEditorImage = New TEditorImage
		
		'add new node, no icon, attach image as EXTRA
		Local node:TGadget = AddTreeViewNode(i.GetEditorName(), image_root, -1, i)
		
		'add node to new image
		i.SetNode(node)
		
		'display it
		ExpandTreeViewNode(image_root)
		SelectTreeViewNode(node)
		OnSelectImage(i)
	End Method

	
		
	
	Method OnAddParticle()
	End Method
		
	Method OnAddEmitter()
	End Method
	
	Method OnAddEffect()
	End Method
	
	Method OnAddProject()
	End Method
	
	
	
	Method OnSaveLibrary()
		
		library.writeconfiguration()
	
	End Method
	

	
	
	
	Method OnMenuExit()
		CloseEditor()
	End Method
	
	
	
	Method OnAbout()
		Notify("ParticlesMAX RRFW Edition by Wiebo de Wit~nALPHA version!")
	End Method
	
	
	
	Method OnChangeAutoLoad()
		If MenuChecked(item_autoload)
			UncheckMenu(item_autoload)
			configFile.SetStringValue("Library", "AutoLoad", "false")
		Else
			CheckMenu(item_autoload)
			configFile.SetStringValue("Library", "AutoLoad", "true")
		EndIf
		UpdateWindowMenu(main_window)
	End Method

	
	
	Method OnChangeAutoSave()
		If MenuChecked(item_autosave)
			UncheckMenu(item_autosave)
			configFile.SetStringValue("Library", "AutoSave", "false")
		Else
			CheckMenu(item_autosave)
			configFile.SetStringValue("Library", "AutoSave", "true")
		EndIf
		UpdateWindowMenu(main_window)
	End Method

	
	
	Method OnChangeShowHelpers()
		If MenuChecked(item_showhelpers)
			UncheckMenu(item_showhelpers)
			configFile.SetStringValue("Layout", "ShowHelpers", "false")
		Else
			CheckMenu(item_showhelpers)
			configFile.SetStringValue("Layout", "ShowHelpers", "true")
		EndIf
		UpdateWindowMenu(main_window)
	End Method	
			
End Type