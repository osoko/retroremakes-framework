

rem
bbdoc: Grids, just like the real thing
endrem
Type TPropertyGrid

	Global instance:TPropertyGrid
	Field gridPanel:TGadget
	Field groupList:TList
	

	rem
	bbdoc: Default constructor
	endrem
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		groupList = New TList
		AddHook(EmitEventHook, MyEventHook)
	End Method


	
	rem
	bbdoc: Creates or returns property grid
	endrem
	Function GetInstance:TPropertyGrid()
		If Not instance Then Return New TPropertyGrid
		Return instance
	End Function

	
	
	rem
	bbdoc: Sets up the property grid. hard-coded for position on the right of the window.
	endrem	
	Method Initialize(x:Int, y:Int, w:Int, h:Int, parent:TGadget)
		gridPanel = CreatePanel(x, y, w, h, parent)
		SetGadgetColor(gridPanel, 255, 255, 255)
		SetGadgetLayout(gridPanel, EDGE_CENTERED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		'set interact gadget width
		INTERACT_WIDTH = w / 2
	End Method
	
	
	
	rem
	bbdoc: Frees the grid and all its contents
	endrem
	Method Free()
		For Local g:TPropertyGroup = EachIn groupList
			g.Free()
		Next
		groupList.Clear()
		FreeGadget gridPanel
		instance = Null
	End Method	
	
	
	
	rem
	bbdoc: arranges groups on the grid
	endrem	
	Method DoLayout()
		Local ypos:Int = 0
		For Local g:TPropertyGroup = EachIn groupList
			g.DoLayout()
			g.SetPosition(ypos)
			ypos:+g.GetHeight()
		Next
	End Method
	
	

	Rem
	bbdoc: Returns list of property groups
	returns: TList
	endrem
	Method GetGroups:TList()
		Return groupList
	End Method
	
	
	
	Rem
	bbdoc: Returns main panel
	endrem	
	Method GetPanel:TGadget()
		Return gridPanel
	End Method
	
	
	
	rem
	bbdoc: Retrieves group by name
	returns: TPropertyGroup if found.
	endrem
	Method GetGroupByName:TPropertyGroup(name:String)
		For Local g:TPropertyGroup = EachIn groupList
			If g.getname() = name Then Return g
		Next
	End Method

	
	
	rem
	bbdoc: Adds a group to the grid
	endrem
	Method AddGroup(g:TPropertyGroup)
		If groupList.Contains(g) Then Return
		groupList.addLast(g)
		g.Show()
		DoLayout()
	End Method


	
	rem
	bbdoc: Removes group from the grid. does not delete it
	endrem
	Method RemoveGroup(g:TPropertyGroup)
		If Not groupList.Contains(g) Then Return
		g.hide()
		groupList.Remove(g)
		DoLayout()
	End Method
	
	
		
	rem
	bbdoc: Hides group from the grid
	endrem
	Method HideGroup(g:TPropertyGroup)
		If Not groupList.Contains(g) Then Return
		g.hide()
		DoLayout()
	End Method	
	
	

	rem
	bbdoc: unhides group from the grid
	endrem
	Method ShowGroup(g:TPropertyGroup)
		If Not groupList.Contains(g) Then Return
		g.show()
		DoLayout()
	End Method
	
		
	
	rem
	bbdoc: Removes and deletes a property group
	endrem
	Method DeleteGroup(g:TPropertyGroup)
		If Not groupList.Contains(g) Then Return
		RemoveGroup(g)
		g.Free()
		DoLayout()
	End Method
	
	
	
	rem
	bbdoc: Passes current event to groups and items to see if action is needed
	endrem	
	Function MyEventHook:Object(id:Int, data:Object, context:Object)
		If Not data Then Return data
		Local event:TEvent = TEvent(data)

		'result wil be true if event for item was handled
		'result will be 2 if a dolayout is needed
		Local result:Int
		
		For Local group:TPropertyGroup = EachIn TPropertyGrid.GetInstance().GetGroups()
			result = group.OnEvent(event)
			
			'handled
			If result = 2 Then TPropertyGrid.GetInstance().DoLayout()
			If result Then Return data
		Next

		'not handled
		Return data
	End Function

End Type
