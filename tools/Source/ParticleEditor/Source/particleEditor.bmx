Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
end rem


'use wxGL and not GL driver!!!
'SetGraphicsDriver wxGLMax2DDriver()


' MAIN_FRAMEbase is in gui.bmx
Type MAIN_FRAME Extends MAIN_FRAMEBase
	
	rem
	bbdoc: Called automatically when the frame is created
	endrem
	Method OnInit()
	
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

	Method OnExportProject(Event:wxCommandEvent)
		Local p:Object = LIBRARY_TREE.GetItemData(_selectedTreeItem)
		If TEditorProject(p) Then LIBRARY.ExportProject(TEditorProject(p), Event)
	End Method


EndRem
	
End Type
