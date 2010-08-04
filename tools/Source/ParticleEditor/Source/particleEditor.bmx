Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
end rem

'

rem
	'changed these lines at the end of wxglmax2d.bmx to prevent
	'the function GLMax2DDriver from clashing with Max2D.GLMax2DDriver
	
	Function wxGLMax2DDriver:TGLMax2DDriver()   <<<<<
		Global _driver:TGLMax2DDriver=New TGLMax2DDriver
		Return _driver
	End Function

	SetGraphicsDriver wxGLMax2DDriver()  <<<<<
end rem

'use wxGL and not GL driver!!!
SetGraphicsDriver wxGLMax2DDriver()


' MAIN_FRAMEbase is in gui.bmx
Type MAIN_FRAME Extends MAIN_FRAMEBase

	
	rem
	bbdoc: Called automatically when the frame is created
	endrem
	Method OnInit()
				
		
		LIBRARY = New TEditorLibraryConfiguration
		If configFile.GetBoolValue("Library", "AutoLoad")
			LIBRARY.ReadConfiguration(configFile.GetStringValue("Library", "LibraryName"))
			FillTree()
			LIBRARY_TREE.expandall()
		End If

	

'		EditorToPropertyGrid()
		PROPERTY_GRID.Refresh()

		ConnectAny(wxEVT_KEY_DOWN, _OnKeyDown)
		ConnectAny(wxEVT_KEY_UP, OnKeyUp)

		SetWindowTitle()
		
'		UPDATE_FREQUENCY = CONFIG.GetValueInt("UpdateFreq")
'		If UPDATE_FREQUENCY = 0 Then UPDATE_FREQUENCY = 50
'		UPDATE_TIME = 1000.0 / UPDATE_FREQUENCY
'		StartEngine()



	End Method


	
	rem
	bbdoc: Clears the library
	endrem
	Method OnClearLibrary(Event:wxCommandEvent)
		If _changes
			Local choice:Int = Proceed("Library contains unsaved changes!~rSave library first?")
			If choice = -1 Then Return		' cancel
			If choice = 1 Then OnSaveLibraryAs(Event:wxCommandEvent)
		End If

'		ENGINE.Clear()
'		LIBRARY.ClearConfiguration()
		LIBRARY_TREE.DeleteChildren(_imageRoot)
		LIBRARY_TREE.DeleteChildren(_particleRoot)
		LIBRARY_TREE.DeleteChildren(_effectRoot)
		LIBRARY_TREE.DeleteChildren(_emitterRoot)
		LIBRARY_TREE.DeleteChildren(_projectRoot)

		configFile.SetStringValue("Library", "LibraryName", "")
		_changes = False
		SetWindowTitle()
	End Method
	
	

	Method OnOpenLibrary(Event:wxCommandEvent)
		If _changes
			Local choice:Int = Proceed("Library contains unsaved changes!~rSave library first?")
			If choice = -1 Then Return		' cancel
			If choice = 1 Then OnSaveLibraryAs(Event:wxCommandEvent)
		End If

		Local newname:String = RequestFile("Open Library", "Library Files:txt;All Files:*")
'		LIBRARY.Clear()
		ClearTree()
		
		'Local ok:Int = LIBRARY.LoadConfiguration(newname)
		'If ok
		'	configFile.SetStringValue("Library", "LibraryName", newname)
		'	FillTree()
		'	LIBRARY_TREE.expandall()
		'	_changes = False
		'EndIf
		SetWindowTitle()
	End Method


	
	
	Method OnSaveLibrary(Event:wxCommandEvent)
		If _changes = False Then Return
		Local newname:String = configFile.GetStringValue("Library", "LibraryName")' CONFIG.GetValueString("library")
		If newname = ""
			newname = RequestFile("Save Library As...", "Library Files:txt;All Files:*", True, "")
		End If
'		Local ok:Int = LIBRARY.SaveConfiguration(newname)
'		If ok
			_changes = False
			configFile.SetStringValue("Library", "LibraryName", newname)
			'CONFIG.SetValue("library", newname)
'		EndIf
		SetWindowTitle()
	End Method
	
	

	Method OnSaveLibraryAs(Event:wxCommandEvent)
	'	Local newname:String = RequestFile("Save Library As...", "Library Files:txt;All Files:*", True, CONFIG.GetValueString("library"))
		'Local ok:Int = LIBRARY.SaveConfiguration(newname)
'		If ok
	'		CONFIG.SetValue("library", newname)
'			_changes = False
'		EndIf
'		SetWindowTitle()
	End Method

	
		


	
	
	Method OnWindowSizeChange(Event:wxSizeEvent)
		Event.skip()
	End Method

	
	


	
	
	Function _OnEngineTick(Event:wxEvent)
'		MAIN_FRAME(Event.parent).OnEngineTick(wxPropertyGridEvent(Event))
	End Function

	
	
	Method OnEngineTick(Event:wxEvent)
'		ENGINE.Update()
	End Method

	Method OnEngineClear(Event:wxCommandEvent)
'		ENGINE.Clear()
	End Method

	Method OnEngineToggle(Event:wxCommandEvent)
'		EngineRunToggle()
	End Method

	Method EngineRunToggle()
'		If GL_engineUpdateTimer.IsRunning()
'			GL_engineUpdateTimer.Stop()
'		Else
'			GL_engineUpdateTimer.Start(UPDATE_TIME)
'		EndIf
	End Method

	Method StartEngine()
		'GL_engineUpdateTimer.Start(UPDATE_TIME)
	End Method

	Method OnSpawnSelection(Event:wxCommandEvent)
		Local x:Int, y:Int
		'RENDER_CANVAS.GetCenter(x, y)
'		LIBRARY.SpawnObject(_selection, x, y)
	End Method

	Function _OnKeyDown(Event:wxEvent)
		MAIN_FRAME(Event.parent).OnKeyDown(Event)
	End Function

	Method OnKeyDown(Event:wxEvent)
		Local evt:wxKeyEvent = wxKeyEvent(Event)
		EmitEvent(CreateEvent(EVENT_KEYDOWN, Event.parent, MapWxKeyCodeToBlitz(evt.GetKeyCode())))
		Event.Skip()
	End Method

	Function OnKeyUp(Event:wxEvent)
		Local evt:wxKeyEvent = wxKeyEvent(Event)
		EmitEvent(CreateEvent(EVENT_KEYUP, Event.parent, MapWxKeyCodeToBlitz(evt.GetKeyCode())))
		Event.Skip()
	End Function



	Method FillTree()
		'
		'read library and add items to editor tree
		Local treeItem:wxTreeItemId

'		For Local i:TEditorImage = EachIn MapValues(LIBRARY._objectMap)
'			treeItem = LIBRARY_TREE.appendItem(_imageRoot, i._name)
'			LIBRARY_TREE.SetItemData(treeItem, i)
'		Next
'		For Local p:TEditorParticle = EachIn MapValues(LIBRARY._objectMap)
'			treeItem = LIBRARY_TREE.appendItem(_particleRoot, p._name)
'			LIBRARY_TREE.SetItemData(treeItem, p)
'		Next
'		For Local p:TEditorEffect = EachIn MapValues(LIBRARY._objectMap)
'			treeItem = LIBRARY_TREE.appendItem(_effectRoot, p._name)
'			LIBRARY_TREE.SetItemData(treeItem, p)
'		Next
'		For Local p:TEditorEmitter = EachIn MapValues(LIBRARY._objectMap)
'			treeItem = LIBRARY_TREE.appendItem(_emitterRoot, p._name)
'			LIBRARY_TREE.SetItemData(treeItem, p)
'		Next
'		For Local p:TEditorProject = EachIn MapValues(LIBRARY._objectMap)
'			treeItem = LIBRARY_TREE.appendItem(_projectRoot, p._name)
'			LIBRARY_TREE.SetItemData(treeItem, p)
'		Next

	End Method



	Method EditorToPropertyGrid()
		Local col:wxColour = New wxColour.Create(RENDER_CANVAS.clearR, RENDER_CANVAS.clearG, RENDER_CANVAS.clearB)
'		PROPERTY_GRID.SetPropertyValueColour("editor_bgcolor", col)
'		PROPERTY_GRID.SetPropertyValueInt("editor_engine_herz", UPDATE_FREQUENCY)
	End Method

	Function _OnPropertyChanging(Event:wxEvent)
		MAIN_FRAME(Event.parent).OnPropertyChanging(wxPropertyGridEvent(Event))
	End Function

	Function _OnPropertyChange(Event:wxEvent)
		MAIN_FRAME(Event.parent).OnPropertyChange(wxPropertyGridEvent(Event))
	End Function

	Method OnPropertyChanging(Event:wxPropertyGridEvent)
		'
		'veto this event (end it) when selection is Null. this is a safe guard, it should never happen.
		'If _selection = Null Then Event.Veto()
	End Method

	Method OnPropertyChange(Event:wxPropertyGridEvent)
		'
		'user changed a property value
		'do editor settings here because they are not an item, cannot be selected

		Local name:String = Event.GetPropertyName()
		Select name
			Case "editor_bgcolor"
				Local col:wxColour = PROPERTY_GRID.GetPropertyValueAsColour(name)
		'		RENDER_CANVAS.setBG(col.Red(),col.Green(),col.blue())
				Return
			Case "editor_engine_herz"
				Local newval:Int = Event.GetPropertyValueAsInt()
				If newval < 20 Then newval = 20
				If newval > 200 Then newval = 200
'				UPDATE_FREQUENCY = newval
	'			UPDATE_TIME = 1000.0 / UPDATE_FREQUENCY
	'			If GL_engineUpdateTimer.IsRunning()
	'				GL_engineUpdateTimer.Stop()
	'				GL_engineUpdateTimer.Start(UPDATE_TIME)
	'			End If
				Return
		End Select

	'	If TEditorImage(_selection) Then TEditorImage(_selection).ChangeSetting(Event, LIBRARY_TREE, _selectedTreeItem)
'		If TEditorParticle(_selection) Then TEditorParticle(_selection).ChangeSetting(Event, LIBRARY_TREE, _selectedTreeItem)
'		If TEditorEffect(_selection) Then TEditorEffect(_selection).ChangeSetting(Event, LIBRARY_TREE, _selectedTreeItem)
'		If TEditorEmitter(_selection) Then TEditorEmitter(_selection).ChangeSetting(Event, LIBRARY_TREE, _selectedTreeItem)
'		If TEditorProject(_selection) Then TEditorProject(_selection).ChangeSetting(Event, LIBRARY_TREE, _selectedTreeItem)

		_changed=True
		SetWindowTitle()
		PROPERTY_GRID.Refresh()
	End Method

	Method TreeItemRightClick(Event:wxTreeEvent)

		Local item:wxTreeItemId = Event.getItem()
		_selectedTreeItem = item
		Local selectedParent:wxTreeItemId = LIBRARY_TREE.GetItemParent(item)

		If selectedParent.isOK()								' make sure there is a parent. (no right click on root )

			If LIBRARY_TREE.getitemtext(item) = "Projects"
				Local menu:wxMenu = New wxMenu.Create()
				menu.Append(MENU_ADD_PROJECT, "Add project", "Add a project")
				PopupMenu(menu)
				menu.Free()
				Return
			EndIf

			Select LIBRARY_TREE.getitemtext(selectedParent)
				Case "Library"
					'
					'clicked on library category
					Select LIBRARY_TREE.getitemtext(item)
						Case "Images"
							Local menu:wxMenu = New wxMenu.Create()
							menu.Append(MENU_ADD_IMAGE, "Add image", "Add an image to the library")
							PopupMenu(menu)
							menu.Free()
						Case "Particles"
							Local menu:wxMenu = New wxMenu.Create()
							menu.Append(MENU_ADD_PARTICLE, "Add particle", "Add particle to the library")
							PopupMenu(menu)
							menu.Free()
						Case "Emitters"
							Local menu:wxMenu = New wxMenu.Create()
							menu.Append(MENU_ADD_EMITTER, "Add emitter", "Add emitter to the library")
							PopupMenu(menu)
							menu.Free()
						Case "Effects"
							Local menu:wxMenu = New wxMenu.Create()
							menu.Append(MENU_ADD_EFFECT, "Add effect", "Add effect to the library")
							PopupMenu(menu)
							menu.Free()

							Default
						'RuntimeError "category " + LIBRARY_TREE.getitemtext(item) + " does not exist"

					End Select

				Case "Images"
					'
					'right clicked on sub item
					Local menu:wxMenu = New wxMenu.Create()
					menu.Append(MENU_CLONE_OBJECT, "Clone", "Clone this object", wxITEM_NORMAL)
					menu.AppendSeparator()
					menu.Append(MENU_DELETE_OBJECT, "Delete", "Delete object from the library", wxITEM_NORMAL)
					PopupMenu(menu)
					menu.Free()

				Case "Particles", "Effects", "Emitters"
					'
					'right clicked on sub item
					Local menu:wxMenu = New wxMenu.Create()
					menu.Append(MENU_CLONE_OBJECT, "Clone", "Clone this object", wxITEM_NORMAL)
					menu.Append(MENU_SPAWN_SELECTION, "Add to Engine", "Show in the engine", wxITEM_NORMAL)
					menu.AppendSeparator()
					menu.Append(MENU_DELETE_OBJECT, "Delete", "Delete object from the library", wxITEM_NORMAL)
					PopupMenu(menu)
					menu.Free()

				Case "Projects"
					'
					'right click on projects sub item
					Local menu:wxMenu = New wxMenu.Create()
					menu.Append(MENU_EXPORT_PROJECT, "Export", "Export project configuration", wxITEM_NORMAL)
					menu.AppendSeparator()
					menu.Append(MENU_CLONE_OBJECT, "Clone", "Clone this project", wxITEM_NORMAL)
					menu.Append(MENU_DELETE_OBJECT, "Delete", "Delete project", wxITEM_NORMAL)
					PopupMenu(menu)
					menu.Free()

			End Select
		EndIf
	End Method

	Method TreeSelectionChange(Event:wxTreeEvent)
		PROPERTY_GRID.ClearSelection()
		PROPERTY_GRID.HideProperty("image_category",True)
		PROPERTY_GRID.HideProperty("particle_category",True)
		PROPERTY_GRID.HideProperty("effect_category",True)
		PROPERTY_GRID.HideProperty("emitter_category",True)
		PROPERTY_GRID.HideProperty("project_category",True)

		_selectedTreeItem = Event.getItem()
		_selection = LIBRARY_TREE.GetItemData(_selectedTreeItem)
		GL_toDraw = _selection

		If TEditorImage(_selection)
			TeditorImage(_selection).FillGridProperty()
			PROPERTY_GRID.HideProperty("image_category",False)
			ENGINE.Clear()
		End If
		If TEditorParticle(_selection)
			TeditorParticle(_selection).FillGridProperty()
			PROPERTY_GRID.HideProperty("particle_category",False)
		End If
		If TEditorEmitter(_selection)
			TEditorEmitter(_selection).FillGridProperty()
			PROPERTY_GRID.HideProperty("emitter_category",False)
		End If
		If TEditorEffect(_selection)
			TEditorEffect(_selection).FillGridProperty()
			PROPERTY_GRID.HideProperty("effect_category",False)
		End If
		If TEditorProject(_selection)
			TEditorProject(_selection).FillGridProperty()
			PROPERTY_GRID.HideProperty("project_category",False)
		End If
		PROPERTY_GRID.Refresh()
	End Method
	
	rem

	Method OnBeginDrag(Event:wxTreeEvent)
		Event.allow()
		Local item:wxTreeItemId = Event.getItem()
		_draggedItem = LIBRARY_TREE.GetItemData(item)
	End Method

	Method OnEndDrag(Event:wxTreeEvent)

		Local destination:wxTreeItemId = Event.getItem()
		Local item:Object = LIBRARY_TREE.GetItemData(destination)

		If TEditorProject(item)
			Local p:TEditorProject = TEditorProject(item)
			If TEditorEmitter(_draggedItem) Then p.AddChild( TEditorEmitter(_draggedItem) ) ; _changed=True	' dropped emitter on project
			If TEditorEffect(_draggedItem) Then p.AddChild( TEditorEffect(_draggedItem) ) ; _changed=True	' dropped effect on project
		ElseIf TEditorEmitter(item)
			Local s:TEditorEmitter = TEditorEmitter(item)
			If TEditorParticle(_draggedItem) Then s.SetSpawnObject( _draggedItem ) ; _changed=True	'dropped particle on emitter
			If TEditorEmitter(_draggedItem) Then s.SetSpawnObject( _draggedItem ) ; _changed=True	'dropped emitter on emitter
		EndIf
		SetWindowTitle()
	End Method

	Method OnItemDelete(Event:wxCommandEvent)
		'
		'get item associated with selection
		Local selectedItem:Object = LIBRARY_TREE.GetItemData(_selectedTreeItem)
		Local removed:Int=False

		If TEditorImage(selectedItem)
			Local item:TEditorImage = TEditorImage(selectedItem)
			removed = LIBRARY.RemoveImage(item)

		ElseIf TEditorParticle(selectedItem)
			Local item:TEditorParticle = TEditorParticle(selectedItem)
			removed = LIBRARY.RemoveParticle(item)

		ElseIf TEditorEffect(selectedItem)
			Local item:TEditorEffect = TEditorEffect(selectedItem)
			removed = LIBRARY.RemoveEffect(item)

		ElseIf TEditorEmitter(selectedItem)
			Local item:TEditorEmitter = TEditorEmitter(selectedItem)
			removed = LIBRARY.RemoveEmitter(item)

		ElseIf TEditorProject(selectedItem)
			Local item:TEditorProject = TEditorProject(selectedItem)
			Local todelete:TEditorProject = TEditorProject(item)
			removed=True
			LIBRARY.RemoveProject(item)
		EndIf

		If removed
			LIBRARY_TREE.DeleteItem(_selectedTreeItem)
			_selectedTreeItem = Null
			_selection = Null
			_changed=True
		EndIf
		SetWindowTitle()
	End Method

	Method OnItemClone(Event:wxCommandEvent)
		'
		'get item associated with selection
		Local selectedItem:Object = LIBRARY_TREE.GetItemData(_selectedTreeItem)

		If TEditorImage(selectedItem)
			Local item:TEditorImage = TEditorImage(selectedItem)
			Local newItem:TEditorImage = New TEditorImage
			item.CopySettingsTo(newItem)
			LIBRARY.AddImage(newItem)
			Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_imageRoot, newItem._name)
			LIBRARY_TREE.SetItemData( newTreeItem, newItem )
			_changed=True

		ElseIf TEditorParticle(selectedItem)
			Local item:TEditorParticle = TEditorParticle(selectedItem)
			Local newItem:TEditorParticle = New TEditorParticle
			item.CopySettingsTo(newItem)
			LIBRARY.AddParticle(newItem)
			Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_particleRoot, newItem._name)
			LIBRARY_TREE.SetItemData( newTreeItem, newItem )
			_changed=True

		ElseIf TEditorEffect(selectedItem)
			Local item:TEditorEffect = TEditorEffect(selectedItem)
			Local newItem:TEditorEffect = New TEditorEffect
			item.CopySettingsTo(newItem)
			LIBRARY.AddEffect(newItem)
			Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_effectRoot, newItem._name)
			LIBRARY_TREE.SetItemData( newTreeItem, newItem )
			_changed=True

		ElseIf TEditorEmitter(selectedItem)
			Local item:TEditorEmitter = TEditorEmitter(selectedItem)
			Local newItem:TEditorEmitter = New TEditorEmitter
			item.CopySettingsTo(newItem)
			LIBRARY.AddEmitter(newItem)
			Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_emitterRoot, newItem._name)
			LIBRARY_TREE.SetItemData( newTreeItem, newItem )
			_changed=True

		ElseIf TEditorProject(selectedItem)
			Local item:TEditorProject = TEditorProject(selectedItem)
			Local newItem:TEditorProject = New TEditorProject
			item.CopySettingsTo(newItem)
			LIBRARY.AddProject(newItem)
			Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_projectRoot, newItem._name)
			LIBRARY_TREE.SetItemData( newTreeItem, newItem )
			_changed=True
		EndIf
		SetWindowTitle()
	End Method

	Method OnExportProject(Event:wxCommandEvent)
		Local p:Object = LIBRARY_TREE.GetItemData(_selectedTreeItem)
		If TEditorProject(p) Then LIBRARY.ExportProject(TEditorProject(p), Event)
	End Method

	Method OnAddProject(Event:wxCommandEvent)
		Local newItem:TEditorProject = New TEditorProject
		LIBRARY.AddProject(newItem)
		Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_projectRoot, newItem._name)
		LIBRARY_TREE.SetItemData(newTreeItem, newItem)
		LIBRARY_TREE.expand(_projectRoot)
		_changed = True
		SetWindowTitle()
	End Method

	Method OnAddImage(Event:wxCommandEvent)
		Local newItem:TEditorImage = New TEditorImage
		newItem.SetName("New Image")
		newItem._frameCount = 1
		LIBRARY.AddImage(newItem)
		Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_imageRoot, newItem._name)
		LIBRARY_TREE.SetItemData(newTreeItem, newItem)
		LIBRARY_TREE.expand(_imageRoot)
		LIBRARY_TREE.selectItem(newTreeItem)
		_changed = True
		SetWindowTitle()
	End Method

	Method OnAddParticle(Event:wxCommandEvent)
		Local newItem:TEditorParticle = New TEditorParticle
		LIBRARY.AddParticle(newItem)
		Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_particleRoot, newItem._name)
		LIBRARY_TREE.SetItemData(newTreeItem, newItem)
		LIBRARY_TREE.expand(_particleRoot)
		LIBRARY_TREE.selectItem(newTreeItem)
		_changed = True
		SetWindowTitle()
	End Method

	Method OnAddEffect(Event:wxCommandEvent)
		Local newItem:TEditorEffect = New TEditorEffect
		LIBRARY.AddEffect(newItem)
		Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_effectRoot, newItem._name)
		LIBRARY_TREE.SetItemData(newTreeItem, newItem)
		LIBRARY_TREE.expand(_effectRoot)
		LIBRARY_TREE.selectItem(newTreeItem)
		_changed = True
		SetWindowTitle()
	End Method

	Method OnAddEmitter(Event:wxCommandEvent)
		Local newItem:TEditorEmitter = New TEditorEmitter
		LIBRARY.AddEmitter(newItem)
		Local newTreeItem:wxTreeItemId = LIBRARY_TREE.appendItem(_emitterRoot, newItem._name)
		LIBRARY_TREE.SetItemData(newTreeItem, newItem)
		LIBRARY_TREE.expand(_emitterRoot)
		LIBRARY_TREE.selectItem(newTreeItem)
		_changed = True
		SetWindowTitle()
	End Method
	
EndRem
	
	


End Type

