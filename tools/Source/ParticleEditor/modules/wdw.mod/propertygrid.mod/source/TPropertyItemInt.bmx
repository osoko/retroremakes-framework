
Function CreatePropertyItemInt:TPropertyItemInt(label:String, value:Int = 0, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemInt.Create(label, value, id, parent)
End Function


Type TPropertyItemInt Extends TPropertyItem

	Method Create:TPropertyItemInt(newLabel:String, defaultValue:Int, id:Int, newParent:TPropertyGroup)

		itemID = id
	
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(interactX, 1, INTERACT_WIDTH, ITEM_SIZE - 2, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		
		AddHook(EmitEventHook, eventHandler, Self, 0)
		
		newParent.AddItem(Self)
		Return Self
	End Method
	
	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemInt = TPropertyItemInt(context)
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
						If GadgetText(interact) = "" Then SetGadgetText(interact, "0")
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
	bbdoc: Returns integer value
	endrem	
	Method GetValue:Int()
		Return Int(GadgetText(interact))
	End Method
	
	
	rem
	bbdoc: Sets integer value
	endrem	
	Method SetValue(value:Int)
		If value Then SetGadgetText(interact, value)
	End Method
		
	
	
	rem
	bbdoc: Filters user input. Only decimals allowed, DEL or -
	endrem	
	Function FilterInput:Int(event:TEvent, context:Object)
		If event.id = EVENT_KEYCHAR
			If event.data = 45 Then Return 1
			If event.data = 8 Then Return 1	'del
			If event.data < 48 Or event.data > 57 Return 0
		EndIf
		Return 1
	End Function
	
	
	
	rem
	bbdoc: Exports integer item to csv string
	endrem	
'	Method ExportToString:String()
'		Return "parameter,integer," + GadgetText(label) + "," + (GadgetText(interact))
'	End Method	
'	Method Clone:TPropertyItem()
'		Local s:TPropertyItemInt = New TPropertyItemInt.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'		Return s
'	End Method
	
End Type

