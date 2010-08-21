
'layout constants
Const GRID_WIDTH:Int = 321
Const INTERACT_WIDTH:Int = 150
Const SLIDER_WIDTH:Int = 21

Const ITEM_INDENT_SIZE:Int = 16
Const ITEM_SIZE:Int = 24
Const ITEM_SPACING:Int = 1


Type TPropertyGrid

	Global instance:TPropertyGrid
	
	'scrollable panel
	Field scrollPanel:TScrollPanel
	
	'items on this grid
	Field groupList:TList

	
	
	rem
	bbdoc: Default constructor
	endrem
	Method New()
		If instance Throw "Cannot create multiple instances of TPropertyGrid!"
		instance = Self
		groupList = New TList
		AddHook(EmitEventHook, eventHandler, Self, -1)
	End Method


	
	rem
	bbdoc: Creates or returns property grid instance
	endrem
	Function GetInstance:TPropertyGrid()
		If Not instance Then Return New TPropertyGrid
		Return instance
	End Function

	
	
	rem
	bbdoc: Sets up the property grid.
	about: location=0 will result in a grid on the left of the parent window
	endrem	
	Method Initialize(parentwindow:TGadget, location:Int = 1)
		Local xpos:Int = ClientWidth(parentwindow) - GRID_WIDTH
		If location = 0 Then xpos = 0

		scrollPanel = CreateScrollPanel(xpos, 0, GRID_WIDTH, ClientHeight(parentwindow), parentwindow, SCROLLPANEL_HNEVER | SCROLLPANEL_VALWAYS)
		If location = 0 Then SetGadgetLayout(scrollPanel, EDGE_ALIGNED, EDGE_CENTERED, EDGE_ALIGNED, EDGE_ALIGNED)
		If location = 1 Then SetGadgetLayout(scrollPanel, EDGE_CENTERED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		SetGadgetColor(ScrollPanelClient(scrollPanel), 255, 255, 255)
		
	End Method
	
	
	
	Rem
	bbdoc: returns panel to which groups are added
	endrem	
	Method GetPanel:Tgadget()
		Return ScrollPanelClient(scrollPanel)
	End Method
	
	
	
	rem
	bbdoc: Frees the property grid
	endrem
	Method CleanUp()
		groupList.Clear()
		scrollPanel.CleanUp()
		instance = Null
		RemoveHook(EmitEventHook, eventHandler, Self)
	End Method	
	
	
	
	rem
	bbdoc: do the layout
	endrem	
	Method Refresh()
		Local ypos:Int = 0
			
		For Local g:TPropertyGroup = EachIn groupList
			g.SetVerticalPosition(ypos)
			
			'make sure group is sized properly
			g.Refresh()
			
			ypos:+g.GetHeight() + ITEM_SPACING
		Next
		
		scrollPanel.FitToChildren()
		
	End Method
	
		
	
	Rem
	bbdoc: Returns group list
	endrem
	Method GetGroups:TList()
		Return groupList
	End Method

	
	
	rem
	bbdoc: Adds group to the grid
	endrem
	Method AddGroup(g:TPropertyGroup)
		If groupList.Contains(g) Then Return
		groupList.AddLast(g)
		Refresh()
	End Method
	
	
		
	rem
	bbdoc: Hides group
	endrem
	Method HideGroup(g:TPropertyGroup)
		If Not groupList.Contains(g) Then Return
		g.Hide()
	End Method
	
	
	
	rem
	bbdoc: Hides all groups on the grid
	endrem
	Method HideAllGroups()
		For Local g:TPropertyGroup = EachIn groupList
			g.Hide()
		Next	
	End Method
	
	

	rem
	bbdoc: Unhides all groups on the grid
	endrem
	Method ShowAllGroups()
		For Local g:TPropertyGroup = EachIn groupList
			g.Show()
		Next	
	End Method
	
	
	
	rem
	bbdoc: Unhides group
	endrem
	Method ShowGroup(g:TPropertyGroup)
		If Not groupList.Contains(g) Then Return
		g.Show()
	End Method
	
	
	
	rem
	bbdoc: Retrieves group by label
	endrem
	Method GetGroupByLabel:TPropertyGroup(label:String)
		For Local g:TPropertyGroup = EachIn groupList
			If g.GetLabel() = label Then Return g
		Next
	End Method
	
	
		
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpPropertyGrid:TPropertyGrid = TPropertyGrid(context)
		If tmpPropertyGrid Then data = tmpPropertyGrid.eventHook(id, data, context)
		Return data
	End Function
	
	
	
	Method eventHook:Object(id:Int, data:Object, context:Object)
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.id
			Case EVENT_PG_GROUPTOGGLE, EVENT_PG_GROUPVISIBLE
				Refresh()
				
			Default
				'no event for this property grid
				Return data
		End Select
		
		'handled, so get rid of old data
		data = Null
	
		Return data
	End Method
		
End Type
