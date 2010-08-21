
Function CreatePropertyItemString:TPropertyItemString(label:String, value:String = "", id:Int, parent:TPropertyGroup)
	Return New TPropertyItemString.Create(label, value, id, parent)
End Function



Type TPropertyItemString Extends TPropertyItem

	Method Create:TPropertyItemString(newLabel:String, defaultValue:String, id:Int, newParent:TPropertyGroup)

		itemID = id
	
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		'interact = CreateTextField(ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - 1, ITEM_SIZE - 3, mainPanel)
		interact = CreateTextField(interactX, 1, INTERACT_WIDTH, ITEM_SIZE - 2, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		
		AddHook(EmitEventHook, eventHandler, Self, 0)
		
		newParent.AddItem(Self)
		Return Self
	End Method
	
	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemString = TPropertyItemString(context)
		If tmpItem Then data = tmpItem.eventHook(id, data, context)
		Return data
	End Function
	
	

	Method eventHook:Object(id:Int, data:Object, context:Object)
	
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.source
			Case interact
				Select tmpEvent.id
					Case EVENT_GADGETLOSTFOCUS
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
	
	
    
	Rem
	bbdoc: Returns string value
	endrem	
	Method GetValue:String()
		Return GadgetText(interact)
	End Method
	
	

	rem
	bbdoc: Sets string value
	about: no = allowed in strings, as export uses = for separator
	endrem
	Method SetValue(value:String)
		value = value.Replace("=", ":")
		SetGadgetText(interact, String(value))
	End Method
	
	
	
	rem
	bbdoc: Filters user input
	endrem	
	Function FilterInput:Int(event:TEvent, context:Object)
		If event.id = EVENT_KEYCHAR
			if event.data = 44 then return 0
		EndIf		
		Return 1
	End Function	
	
	

	rem
	bbdoc: Exports string item to string
	endrem
	Method ExportToString:String()
		Return "parameter,string," + GadgetText(label) + "," + GadgetText(interact)
	End Method
    
	
	
'	Method Clone:TPropertyItem()
'		Return New TPropertyItemString.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'	End Method
	
End Type


