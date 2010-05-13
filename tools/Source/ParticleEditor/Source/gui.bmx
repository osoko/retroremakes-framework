'
' BlitzMax code generated with wxCodeGen v1.06 : 29 Jul 2009 23:49:18
' 
' 
' PLEASE DO "NOT" EDIT THIS FILE!
' 
SuperStrict

Import wx.wxFrame
Import wx.wxMenu
Import wx.wxMenuBar
Import wx.wxPanel
Import wx.wxSplitterWindow
Import wx.wxTreeCtrl
Import wx.wxWindow


Type MAIN_FRAMEBase Extends wxFrame

	Field left_splitter:wxSplitterWindow
	Field library_panel:wxPanel
	Field LIBRARY_TREE:wxTreeCtrl
	Field m_panel_right:wxPanel
	Field right_splitter:wxSplitterWindow
	Field m_panel_render:wxPanel
	Field render_sizer:wxBoxSizer
	Field m_panel_propgrid:wxPanel
	Field propgrid_sizer:wxBoxSizer
	Field m_menubar1:wxMenuBar
	Field file_menu:wxMenu
	Field edit_menu:wxMenu
	Field options_menu:wxMenu
	Field menuItem_LoadLastLib:wxMenuItem
	Field menuItem_AutoSave:wxMenuItem
	Field engine_menu:wxMenu
	Field menuItem_ShowHelpers:wxMenuItem
	Field about_menu:wxMenu

	Const MENU_SAVE_LIBRARY:Int = 1000
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

	Method Create:MAIN_FRAMEBase(parent:wxWindow = Null, id:Int = wxID_ANY, title:String = "RRFW ParticlesMAX", x:Int = -1, y:Int = -1, w:Int = 507, h:Int = 500, style:Int = wxDEFAULT_FRAME_STYLE | wxTAB_TRAVERSAL)
		return MAIN_FRAMEBase(Super.Create(parent, id, title, x, y, w, h, style))
	End Method

	Method OnInit()

		Local main_sizer:wxBoxSizer
		main_sizer = new wxBoxSizer.Create(wxHORIZONTAL)
		left_splitter = new wxSplitterWindow.Create(Self, wxID_ANY,,, -1,-1, wxSP_NOBORDER)
		library_panel = new wxPanel.Create(left_splitter, wxID_ANY,,, -1,-1, wxTAB_TRAVERSAL)

		Local library_sizer:wxBoxSizer
		library_sizer = new wxBoxSizer.Create(wxHORIZONTAL)
		LIBRARY_TREE = new wxTreeCtrl.Create(library_panel, wxID_ANY,,, -1,-1, wxTR_DEFAULT_STYLE)
		library_sizer.Add(LIBRARY_TREE, 1, wxEXPAND, 5)

		library_panel.SetSizer(library_sizer)
		library_panel.Layout()
		library_sizer.Fit(library_panel)

		m_panel_right = new wxPanel.Create(left_splitter, wxID_ANY)

		Local right_sizer:wxBoxSizer
		right_sizer = new wxBoxSizer.Create(wxHORIZONTAL)
		right_splitter = new wxSplitterWindow.Create(m_panel_right, wxID_ANY,,,,, wxSP_NOBORDER)
		m_panel_render = new wxPanel.Create(right_splitter, wxID_ANY,,,,, wxTAB_TRAVERSAL)

		render_sizer = new wxBoxSizer.Create(wxVERTICAL)
		m_panel_render.SetSizer(render_sizer)
		m_panel_render.Layout()
		render_sizer.Fit(m_panel_render)

		m_panel_propgrid = new wxPanel.Create(right_splitter, wxID_ANY,,,,, wxTAB_TRAVERSAL)

		propgrid_sizer = new wxBoxSizer.Create(wxHORIZONTAL)
		m_panel_propgrid.SetSizer(propgrid_sizer)
		m_panel_propgrid.Layout()
		propgrid_sizer.Fit(m_panel_propgrid)

		right_splitter.SplitVertically(m_panel_render, m_panel_propgrid, 383)
		right_splitter.SetMinimumPaneSize(200)

		right_sizer.Add(right_splitter, 1, wxALIGN_RIGHT|wxEXPAND, 5)

		m_panel_right.SetSizer(right_sizer)
		m_panel_right.Layout()
		right_sizer.Fit(m_panel_right)

		left_splitter.SplitVertically(library_panel, m_panel_right, 200)
		left_splitter.SetMinimumPaneSize(200)

		main_sizer.Add(left_splitter, 1, wxEXPAND, 5)

		m_menubar1 = new wxMenuBar.Create()

		file_menu = new wxMenu.Create()

		Local menuItem_ClearLib:wxMenuItem
		menuItem_ClearLib = new wxMenuItem.Create(file_menu, wxID_ANY, "New Library" + "	Ctrl-N", "", wxITEM_NORMAL)
		file_menu.AppendItem(menuItem_ClearLib)

		file_menu.AppendSeparator()

		Local menuItem_OpenLib:wxMenuItem
		menuItem_OpenLib = new wxMenuItem.Create(file_menu, wxID_ANY, "Open Library" + "	Ctrl-O", "", wxITEM_NORMAL)
		file_menu.AppendItem(menuItem_OpenLib)

		Local menuItem_SaveLib:wxMenuItem
		menuItem_SaveLib = new wxMenuItem.Create(file_menu, MENU_SAVE_LIBRARY, "Save Library" + "	Ctrl-S", "", wxITEM_NORMAL)
		file_menu.AppendItem(menuItem_SaveLib)

		Local menuItem_SaveAs:wxMenuItem
		menuItem_SaveAs = new wxMenuItem.Create(file_menu, wxID_ANY, "Save Library As..." + "	Ctrl-Shift-S", "", wxITEM_NORMAL)
		file_menu.AppendItem(menuItem_SaveAs)

		file_menu.AppendSeparator()

		Local menuItem_exportProject:wxMenuItem
		menuItem_exportProject = new wxMenuItem.Create(file_menu, MENU_EXPORT_PROJECT, "Export Project" + "	Ctrl-E", "", wxITEM_NORMAL)
		file_menu.AppendItem(menuItem_exportProject)

		file_menu.AppendSeparator()

		Local menuItem_exit:wxMenuItem
		menuItem_exit = new wxMenuItem.Create(file_menu, MENU_EXIT, "Exit" + "	Alt-F4", "", wxITEM_NORMAL)
		file_menu.AppendItem(menuItem_exit)
		m_menubar1.Append(file_menu, "File")

		edit_menu = new wxMenu.Create()

		Local menuItem_addImage:wxMenuItem
		menuItem_addImage = new wxMenuItem.Create(edit_menu, MENU_ADD_IMAGE, "Add Image", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_addImage)

		Local menuItem_addParticle:wxMenuItem
		menuItem_addParticle = new wxMenuItem.Create(edit_menu, MENU_ADD_PARTICLE, "Add Particle", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_addParticle)

		Local menuItem_addEmitter:wxMenuItem
		menuItem_addEmitter = new wxMenuItem.Create(edit_menu, MENU_ADD_EMITTER, "Add Emitter", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_addEmitter)

		Local menuItem_addEffect:wxMenuItem
		menuItem_addEffect = new wxMenuItem.Create(edit_menu, MENU_ADD_EFFECT, "Add Effect", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_addEffect)

		Local menuItem_addProject:wxMenuItem
		menuItem_addProject = new wxMenuItem.Create(edit_menu, MENU_ADD_PROJECT, "Add Project", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_addProject)

		edit_menu.AppendSeparator()

		Local menuItem_deleteSelection:wxMenuItem
		menuItem_deleteSelection = new wxMenuItem.Create(edit_menu, MENU_DELETE_OBJECT, "Delete Selection" + "	Ctrl-Del", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_deleteSelection)

		Local menuItem_cloneSelection:wxMenuItem
		menuItem_cloneSelection = new wxMenuItem.Create(edit_menu, MENU_CLONE_OBJECT, "Clone Selection" + "	Ctrl+C", "", wxITEM_NORMAL)
		edit_menu.AppendItem(menuItem_cloneSelection)
		m_menubar1.Append(edit_menu, "Edit")

		options_menu = new wxMenu.Create()

		menuItem_LoadLastLib = new wxMenuItem.Create(options_menu, MENU_AUTOLOAD, "Load Library On Startup", "", wxITEM_CHECK)
		options_menu.AppendItem(menuItem_LoadLastLib)

		menuItem_AutoSave = new wxMenuItem.Create(options_menu, MENU_AUTOSAVE, "Save Library On Exit", "", wxITEM_CHECK)
		options_menu.AppendItem(menuItem_AutoSave)
		m_menubar1.Append(options_menu, "Options")

		engine_menu = new wxMenu.Create()

		Local menuItem_spawnSelection:wxMenuItem
		menuItem_spawnSelection = new wxMenuItem.Create(engine_menu, MENU_SPAWN_SELECTION, "Spawn Selection" + "	F5", "", wxITEM_NORMAL)
		engine_menu.AppendItem(menuItem_spawnSelection)

		Local menuItem_toggleEngine:wxMenuItem
		menuItem_toggleEngine = new wxMenuItem.Create(engine_menu, MENU_TOGGLE_ENGINE, "Toggle Engine" + "	F8", "", wxITEM_NORMAL)
		engine_menu.AppendItem(menuItem_toggleEngine)

		Local menuItem_clearEngine:wxMenuItem
		menuItem_clearEngine = new wxMenuItem.Create(engine_menu, MENU_CLEAR_ENGINE, "Clear" + "	F6", "", wxITEM_NORMAL)
		engine_menu.AppendItem(menuItem_clearEngine)

		engine_menu.AppendSeparator()

		menuItem_ShowHelpers = new wxMenuItem.Create(engine_menu, MENU_SHOWHELPERS, "Show Helpers" + "	Ctrl-H", "", wxITEM_CHECK)
		engine_menu.AppendItem(menuItem_ShowHelpers)
		m_menubar1.Append(engine_menu, "Preview")

		about_menu = new wxMenu.Create()

		Local menuItem_About:wxMenuItem
		menuItem_About = new wxMenuItem.Create(about_menu, MENU_ABOUT, "About..." + "	F1", "", wxITEM_NORMAL)
		about_menu.AppendItem(menuItem_About)
		m_menubar1.Append(about_menu, "About")
		SetMenuBar(m_menubar1)

		SetSizer(main_sizer)
		Layout()
		Center(wxBOTH)

		ConnectAny(wxEVT_CLOSE_WINDOW, _OnClose)
		ConnectAny(wxEVT_SIZE, _OnWindowSizeChange)
		LIBRARY_TREE.ConnectAny(wxEVT_COMMAND_TREE_BEGIN_DRAG, _OnBeginDrag, Null, Self)
		LIBRARY_TREE.ConnectAny(wxEVT_COMMAND_TREE_END_DRAG, _OnEndDrag, Null, Self)
		LIBRARY_TREE.ConnectAny(wxEVT_COMMAND_TREE_ITEM_RIGHT_CLICK, _TreeItemRightClick, Null, Self)
		LIBRARY_TREE.ConnectAny(wxEVT_COMMAND_TREE_SEL_CHANGED, _TreeSelectionChange, Null, Self)
		Connect(menuItem_ClearLib.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnClearLibrary)
		Connect(menuItem_OpenLib.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnOpenLibrary)
		Connect(menuItem_SaveLib.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnSaveLibrary)
		Connect(menuItem_SaveAs.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnSaveLibraryAs)
		Connect(menuItem_exportProject.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnExportProject)
		Connect(menuItem_exit.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnClose)
		Connect(menuItem_addImage.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnAddImage)
		Connect(menuItem_addParticle.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnAddParticle)
		Connect(menuItem_addEmitter.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnAddEmitter)
		Connect(menuItem_addEffect.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnAddEffect)
		Connect(menuItem_addProject.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnAddProject)
		Connect(menuItem_deleteSelection.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnItemDelete)
		Connect(menuItem_cloneSelection.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnItemClone)
		Connect(menuItem_LoadLastLib.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnChangeAutoLoad)
		Connect(menuItem_AutoSave.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnChangeAutoSave)
		Connect(menuItem_spawnSelection.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnSpawnSelection)
		Connect(menuItem_toggleEngine.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnEngineToggle)
		Connect(menuItem_clearEngine.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnEngineClear)
		Connect(menuItem_ShowHelpers.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnChangeShowHelpers)
		Connect(menuItem_About.GetId(), wxEVT_COMMAND_MENU_SELECTED, _OnAbout)
	End Method

	Function _OnClose(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnClose(wxCloseEvent(event))
	End Function

	Method OnClose(event:wxCloseEvent)
		DebugLog "Please override MAIN_FRAME.OnClose()"
		event.Skip()
	End Method

	Function _OnWindowSizeChange(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnWindowSizeChange(wxSizeEvent(event))
	End Function

	Method OnWindowSizeChange(event:wxSizeEvent)
		DebugLog "Please override MAIN_FRAME.OnWindowSizeChange()"
		event.Skip()
	End Method

	Function _OnBeginDrag(event:wxEvent)
		MAIN_FRAMEBase(event.sink).OnBeginDrag(wxTreeEvent(event))
	End Function

	Method OnBeginDrag(event:wxTreeEvent)
		DebugLog "Please override MAIN_FRAME.OnBeginDrag()"
		event.Skip()
	End Method

	Function _OnEndDrag(event:wxEvent)
		MAIN_FRAMEBase(event.sink).OnEndDrag(wxTreeEvent(event))
	End Function

	Method OnEndDrag(event:wxTreeEvent)
		DebugLog "Please override MAIN_FRAME.OnEndDrag()"
		event.Skip()
	End Method

	Function _TreeItemRightClick(event:wxEvent)
		MAIN_FRAMEBase(event.sink).TreeItemRightClick(wxTreeEvent(event))
	End Function

	Method TreeItemRightClick(event:wxTreeEvent)
		DebugLog "Please override MAIN_FRAME.TreeItemRightClick()"
		event.Skip()
	End Method

	Function _TreeSelectionChange(event:wxEvent)
		MAIN_FRAMEBase(event.sink).TreeSelectionChange(wxTreeEvent(event))
	End Function

	Method TreeSelectionChange(event:wxTreeEvent)
		DebugLog "Please override MAIN_FRAME.TreeSelectionChange()"
		event.Skip()
	End Method

	Function _OnClearLibrary(event:wxEvent)
		MAIN_FRAMEBase(event.sink).OnClearLibrary(wxCommandEvent(event))
	End Function

	Method OnClearLibrary(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnClearLibrary()"
		event.Skip()
	End Method

	Function _OnOpenLibrary(event:wxEvent)
		MAIN_FRAMEBase(event.sink).OnOpenLibrary(wxCommandEvent(event))
	End Function

	Method OnOpenLibrary(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnOpenLibrary()"
		event.Skip()
	End Method

	Function _OnSaveLibrary(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnSaveLibrary(wxCommandEvent(event))
	End Function

	Method OnSaveLibrary(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnSaveLibrary()"
		event.Skip()
	End Method

	Function _OnSaveLibraryAs(event:wxEvent)
		MAIN_FRAMEBase(event.sink).OnSaveLibraryAs(wxCommandEvent(event))
	End Function

	Method OnSaveLibraryAs(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnSaveLibraryAs()"
		event.Skip()
	End Method

	Function _OnExportProject(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnExportProject(wxCommandEvent(event))
	End Function

	Method OnExportProject(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnExportProject()"
		event.Skip()
	End Method

	Function _OnAddImage(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnAddImage(wxCommandEvent(event))
	End Function

	Method OnAddImage(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnAddImage()"
		event.Skip()
	End Method

	Function _OnAddParticle(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnAddParticle(wxCommandEvent(event))
	End Function

	Method OnAddParticle(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnAddParticle()"
		event.Skip()
	End Method

	Function _OnAddEmitter(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnAddEmitter(wxCommandEvent(event))
	End Function

	Method OnAddEmitter(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnAddEmitter()"
		event.Skip()
	End Method

	Function _OnAddEffect(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnAddEffect(wxCommandEvent(event))
	End Function

	Method OnAddEffect(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnAddEffect()"
		event.Skip()
	End Method

	Function _OnAddProject(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnAddProject(wxCommandEvent(event))
	End Function

	Method OnAddProject(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnAddProject()"
		event.Skip()
	End Method

	Function _OnItemDelete(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnItemDelete(wxCommandEvent(event))
	End Function

	Method OnItemDelete(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnItemDelete()"
		event.Skip()
	End Method

	Function _OnItemClone(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnItemClone(wxCommandEvent(event))
	End Function

	Method OnItemClone(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnItemClone()"
		event.Skip()
	End Method

	Function _OnChangeAutoLoad(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnChangeAutoLoad(wxCommandEvent(event))
	End Function

	Method OnChangeAutoLoad(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnChangeAutoLoad()"
		event.Skip()
	End Method

	Function _OnChangeAutoSave(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnChangeAutoSave(wxCommandEvent(event))
	End Function

	Method OnChangeAutoSave(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnChangeAutoSave()"
		event.Skip()
	End Method

	Function _OnSpawnSelection(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnSpawnSelection(wxCommandEvent(event))
	End Function

	Method OnSpawnSelection(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnSpawnSelection()"
		event.Skip()
	End Method

	Function _OnEngineToggle(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnEngineToggle(wxCommandEvent(event))
	End Function

	Method OnEngineToggle(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnEngineToggle()"
		event.Skip()
	End Method

	Function _OnEngineClear(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnEngineClear(wxCommandEvent(event))
	End Function

	Method OnEngineClear(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnEngineClear()"
		event.Skip()
	End Method

	Function _OnChangeShowHelpers(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnChangeShowHelpers(wxCommandEvent(event))
	End Function

	Method OnChangeShowHelpers(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnChangeShowHelpers()"
		event.Skip()
	End Method

	Function _OnAbout(event:wxEvent)
		MAIN_FRAMEBase(event.parent).OnAbout(wxCommandEvent(event))
	End Function

	Method OnAbout(event:wxCommandEvent)
		DebugLog "Please override MAIN_FRAME.OnAbout()"
		event.Skip()
	End Method

End Type

