
Function CreatePropertyItemChoice:TPropertyItemChoice(label:String, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemChoice.Create(label, id, parent)
End Function


Type TPropertyItemChoice Extends TPropertyItem

	Method Create:TPropertyItemChoice(newLabel:String, id:Int, newParent:TPropertyGroup)
		itemID = id
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)
		
		interact = CreateComboBox(interactX, 0, INTERACT_WIDTH, ITEM_SIZE, mainPanel, 0)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		
		AddHook(EmitEventHook, eventHandler, Self, 0)
		newParent.AddItem(Self)
		Return Self
	End Method
	
	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemChoice = TPropertyItemChoice(context)
		If tmpItem Then data = tmpItem.eventHook(id, data, context)
		Return data
	End Function
	
	
	
	Method eventHook:Object(id:Int, data:Object, context:Object)
	
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.source
			Case interact
				Select tmpEvent.id
					Case EVENT_GADGETACTION
						CreateItemEvent(EVENT_PG_ITEMCHANGED, GadgetText(interact))
						
					Default
						'it is an event we're not interested in.
						Return data
				End Select
				
				'handled, so get rid of old data
				data = Null
				
			Default
				'no event for this item
				Return data
		End Select

		Return data
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
