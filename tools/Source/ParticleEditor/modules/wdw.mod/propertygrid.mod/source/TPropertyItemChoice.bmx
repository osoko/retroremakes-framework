
Function CreatePropertyItemChoice:TPropertyItemChoice(label:String, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemChoice.Create(label, id, parent)
End Function


Type TPropertyItemChoice Extends TPropertyItem

	Method Create:TPropertyItemChoice(newLabel:String, id:Int, newParent:TPropertyGroup)

		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)
		
		interact = CreateComboBox(ClientWidth(mainPanel) - INTERACT_WIDTH, 0, INTERACT_WIDTH - 1, ITEM_SIZE, mainPanel, 0)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetParent(newParent)
		itemID = id
		Return Self
	End Method
	
	

	rem
	bbdoc: Event handler for this item
	about: Raises an event if the item has been changed
	returns: True if the passed event was for this item
	endrem
	Method OnEvent:Int(event:TEvent)
		If event.source = interact And event.id = EVENT_GADGETACTION
			CreateItemEvent(EVENT_ITEMCHANGED, String(SelectedGadgetItem(interact)))
			Return True
		EndIf
		Return False
	End Method

	

	rem
	bbdoc: Add choice option
	endrem	
	Method AddItem(itemLabel:String)
		AddGadgetItem interact, itemLabel
	End Method

	
		
	rem
	bbdoc: Removes all options
	endrem 
	Method RemoveItems()
		ClearGadgetItems(interact)
	End Method
	
	

	rem
	bbdoc: Returns index of selected choice
	endrem	
	Method GetValue:Int()
		Return SelectedGadgetItem(interact)
	End Method

		

	rem
	bbdoc: Sets choice to passed index
	endrem	
	Method SetIndexValue(index:Int)
		SelectGadgetItem(interact, index)
	End Method
	
	
	
	rem
	bbdoc: Exports choice to csv string
	endrem	
	Method ExportToString:String()
		Return "parameter,choice," + GadgetText(label) + "," + SelectedGadgetItem(interact)
	End Method	
	
	
	
'	Method Clone:TPropertyItem()
'		Local s:TPropertyItemChoice = New TPropertyItemChoice.Create(Self.GetName(), Self.GetParent())
'		
'		Local label:String
'		For Local index:Int = 0 To CountGadgetItems(interact) - 1
'			AddGadgetItem(s.interact, GadgetItemText(interact, index))
'		Next
'		SelectGadgetItem(s.interact, SelectedGadgetItem(interact))
'		
'		Return s
'	End Method	
	
End Type
