
Function CreatePropertyItemBool:TPropertyItemBool(label:String, value:Int = 1, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemBool.Create(label, value, id, parent)
End Function


Type TPropertyItemBool Extends TPropertyItem

	Method Create:TPropertyItemBool(newLabel:String, defaultValue:Int, id:Int, newParent:TPropertyGroup)

		itemID = id
	
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)
		
		interact = CreateButton("", interactX, 1, INTERACT_WIDTH - 1, ITEM_SIZE - 2, mainPanel, BUTTON_CHECKBOX)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetButtonState(interact, defaultValue)
		UpdateBoolText()

		AddHook(EmitEventHook, eventHandler, Self, 0)
		newParent.AddItem(Self)
		Return Self
	End Method
	
	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemBool = TPropertyItemBool(context)
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
						UpdateBoolText()
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
	bbdoc: Updates item text according to bool value
	endrem	
	Method UpdateBoolText()
		If ButtonState(interact) = True Then SetGadgetText(interact, "True")
		If ButtonState(interact) = False Then SetGadgetText(interact, "False")
	EndMethod
	


	rem
	bbdoc: Returns bool value status
	endrem
	Method GetValue:Int()
		Return ButtonState(interact)
	End Method
	

		
	rem
	bbdoc: Returns bool status
	endrem	
	Method SetValue(bool:Int)
		SetButtonState(interact, bool)
		UpdateBoolText()
	End Method
	
	
	
	rem
	bbdoc: Exports bool value to csv string
	endrem	
	Method ExportToString:String()
		Return "parameter,bool," + GadgetText(label) + "," + ButtonState(interact)
	End Method	
	
	

'	Method Clone:TPropertyItem()
'		Local s:TPropertyItemBool = New TPropertyItemBool.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'		Return s
'	End Method	
	
End Type

