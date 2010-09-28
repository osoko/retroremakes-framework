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
	
	'last dragged object
	Field draggedItem:Object

	'true when library items have changed
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
			library.ReadConfiguration(configFile.GetStringValue("Library", "LibraryName"))
			
	End Method

	
	
	Method SetupLibrary()
		library = New TEditorLibrary
		library.SetReader(New TEditorReader)
		library.SetWriter(New TEditorWriter)
	End Method
	

	
	Method OnClearLibrary:Int()
	
		If changed
			Local result:Int, choice:Int

			choice = Proceed("Current library contains unsaved changes!~rSave it first?")
			If choice = -1 Then Return False
			If choice = 1 Then result = OnSaveLibraryAs()
			If result = False Then Return False
		End If

		property_grid.HideAllGroups()
		ClearTreeView(tree_view)

		library.Clear()
		SetupTree()
		
		Return True
		
	End Method
	
	
	
	Method OnOpenLibrary()
	
		If OnClearLibrary() = False Then Return

		'load a new library
		Local fileName:String=RequestFile("Open Library", "Library Files:lib",False,AppDir)
		library.ReadConfiguration(fileName)
		
		'save name in editor config file
		configFile.SetStringValue("Library","LibraryName", fileName)
		
		PopulateTree()
		changed=False
		SetWindowTitle()

	End Method
	


	Method OnSaveLibrary()
		If Not changed Return
		library.WriteConfiguration(library.filename)
		changed=False
		SetWindowTitle()
	End Method
	
	
	
	Method OnSaveLibraryAs:Int()
		Local newName:String = RequestFile("Save Library as...","Library Files:lib",True,AppDir)
		If newName="" Then Return False
		library.WriteConfiguration(newName)
		changed = False
		SetWindowTitle()
		Return True
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
	
		Local o:Object
		For Local l:TLibraryObject= EachIn library.GetObjectList()
			o = l.GetObject()
			
			If TEditorImage(o)
				Local i:TEditorImage=TEditorImage(o)
				Local node:TGadget = AddTreeViewNode(i.GetEditorName(), image_root, -1, i)
				i.SetNode(node)
			EndIf
			
			'etc
			
			
			
		Next
		
		'show all
		ExpandTreeViewNode(image_root)
		ExpandTreeViewNode(particle_root)
		ExpandTreeViewNode(emitter_root)
		ExpandTreeViewNode(effect_root)
		ExpandTreeViewNode(project_root)
		
	End Method
	

	
	rem
	bbdoc: Clean up, and end the editor
	endrem	
	Method CloseEditor()
		If configFile.GetBoolValue("Library", "AutoSave") = True Then OnSaveLibrary()
		configFile.Save()
		
		'stop timers, etc
		
		End
	End Method	

	
	
	rem
	bbdoc: Determines the selected treeview gadget and refreshes the propertygrid
	about: Called when user selects a treeview gadget
	endrem
	Method OnGadgetSelect()
		Local node:TGadget = SelectedTreeViewNode(tree_view)
		
		If node=Null Then Return
		
		Local extra:Object = GadgetExtra(node)
		
		If TEditorImage(extra)
			selection = extra
			TEditorImage(extra).SetPropertyGroupItems()
			property_grid.HideAllGroups()
			property_grid.ShowGroup(image_group)
			Return
		EndIf

		
		'etc

	End Method
	
	
	
	rem
	bbdoc:
	about: Called when user changes an item in the property grid
	endrem
	Method OnItemChange(i:TPropertyItem)
	
		If TEditorImage(selection) Then TEditorImage(selection).ChangeSetting(i) ; Return
		
		'etc
		
		changed=True
		SetWindowTitle()
	End Method
	
	
	
	rem
	bbdoc: Adds a new image to the library
	endrem
	Method OnAddImage()
		Local i:TEditorImage = New TEditorImage
		
		'add it to the library
		Local id:Int = library.AddObject(i)
		i.SetID(id)
				
		'add treeview node, no icon, attach image as EXTRA
		Local node:TGadget = AddTreeViewNode(i.GetEditorName(), image_root, -1, i)
		
		'add node to new image
		i.SetNode(node)
		
		ExpandTreeViewNode(image_root)
		
		changed=True
		SetWindowTitle()
	End Method

			
	
	Method OnAddParticle()
	End Method
		
	Method OnAddEmitter()
	End Method
	
	Method OnAddEffect()
	End Method
	
	Method OnAddProject()
	End Method
	

	
	Method OnCloneObject()
		Local obj:Object = GadgetExtra(SelectedTreeViewNode(tree_view))
		If obj = Null Then Return
		
		If TEditorImage(obj) 
			Local newImage:TEditorImage = TEditorImage(obj).Clone()
			Local id:Int=library.AddObject(newImage)
			newImage.SetID(id)
			Local node:TGadget = AddTreeViewNode(newImage.GetEditorName(), image_root, -1, newImage)
			newImage.SetNode(node)
			ExpandTreeViewNode(image_root)
			Return
		EndIf
		
		'etc
		
		changed=True
		SetWindowTitle()
	End Method
	
	
	
	Method OnDeleteObject()
		Local obj:Object = GadgetExtra(SelectedTreeViewNode(tree_view))
		If obj=Null Then Return
		
		Local removed:Int=False
				
		If TEditorImage(obj) Then removed = library.RemoveImage(TEditorImage(obj))
		
		'etc
		
		
		'continue
		If removed
			FreeGadget(SelectedTreeViewNode(tree_view))
			SelectTreeViewNode(image_root)
			selection = Null
			property_grid.HideAllGroups()

			changed=True
			SetWindowTitle()
		End If
		
	End Method
	
	
	Method OnMenuExit()
		CloseEditor()
	End Method
	
	
	
	Method OnAbout()
		Notify("ParticlesMAX RRFW Edition by Wiebo de Wit~nWay To Early version!")
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
	
		
	
	rem
	bbdoc: Sets window title to reflect loaded library
	endrem
	Method SetWindowTitle()
		Local title:String = "" + APP_NAME + " - " + StripDir(configFile.GetStringValue("Library", "LibraryName"))
		If changed Then title:+"*"
		SetGadgetText(main_window, title)
	End Method
			
End Type