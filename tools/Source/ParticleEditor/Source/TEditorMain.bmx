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
		
		If configFile.GetBoolValue("Library", "AutoLoad") = True Then LoadLibrary()
	End Method
	


	rem
	bbdoc: Main execution loop
	endrem
	Method Run()
		Repeat
			WaitEvent()
			Select EventID()
				Case EVENT_WINDOWCLOSE, EVENT_APPTERMINATE
					OnMenuExit()
				Case EVENT_MENUACTION
					OnMenuAction()
			End Select
		Forever
	End Method
	
	
	
	Method LoadLibrary()
		
	End Method
	
	
	Method SaveLibrary()
		
	End Method
	
	
	
	rem
	bbdoc: Loads ini file
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
'		SetClsColor(array[0], array[1], array[2])
	End Method
	

	
	
	rem
	bbdoc: Populates tree view with items from the loaded library
	endrem
	Method PopulateTree()
		
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
		If configFile.GetBoolValue("Library", "AutoSave") = True Then SaveLibrary()
		configFile.Save()
		
		'stop timers, etc
		
		End
	End Method	
		
	
	
	rem
	bbdoc: Sets window title to reflect loaded library
	endrem
	Method SetWindowTitle()
		If changed = False Then SetGadgetText(main_window, APP_NAME + StripDir(configFile.GetStringValue("Library", "LibraryName")))
		If changed = True Then SetGadgetText(main_window, APP_NAME + StripDir(configFile.GetStringValue("Library", "LibraryName") + "*"))
	End Method	
	
	
	
	
	
	
	
	
	
	
	'---------------------------------------------------------
	'GUI override methods
	
	Method OnMenuExit()
		CloseEditor()
	End Method
	
	
	
	Method OnAbout()
		Notify("RRFW ParticlesMAX by Wiebo de Wit~nALPHA version!")
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