
Function CreatePropertyItemInt:TPropertyItemInt(label:String, value:Int = 0, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemInt.Create(label, value, id, parent)
End Function


Type TPropertyItemInt Extends TPropertyItem

	Method Create:TPropertyItemInt(newLabel:String, defaultValue:Int, id:Int, newParent:TPropertyGroup)

		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - 1, ITEM_SIZE - 3, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		itemID = id
		SetParent(newParent)
		Return Self
	End Method
	
	

	rem
	bbdoc: Event handler for this item
	endrem
	Method OnEvent:Int(event:TEvent)
		If event.source = interact And event.id = EVENT_GADGETLOSTFOCUS
			If GadgetText(interact) = "" Then SetGadgetText(interact, "0")
			CreateItemEvent(EVENT_ITEMCHANGED, GadgetText(interact))
			Return True
		EndIf
		Return False
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
	bbdoc: Filters user input. Only decimals allowed
	endrem	
	Function FilterInput:Int(event:TEvent, context:Object)
		If event.id = EVENT_KEYCHAR
			If event.data = 8 Then Return 1
			If event.data < 48 Or event.data > 57 Return 0
		EndIf
		Return 1
	End Function
	
	
	
	rem
	bbdoc: Exports integer item to csv string
	endrem	
	Method ExportToString:String()
		Return "parameter,integer," + GadgetText(label) + "," + (GadgetText(interact))
	End Method	
	
	
'	Method Clone:TPropertyItem()
'		Local s:TPropertyItemInt = New TPropertyItemInt.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'		Return s
'	End Method
	
End Type

