
Function CreatePropertyItemString:TPropertyItemString(label:String, value:String = "", id:Int, parent:TPropertyGroup)
	Return New TPropertyItemString.Create(label, value, id, parent)
End Function


Type TPropertyItemString Extends TPropertyItem

	Method Create:TPropertyItemString(newLabel:String, defaultValue:String, id:Int, newParent:TPropertyGroup)

		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - 1, ITEM_SIZE - 3, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		'SetGadgetToolTip(label, "")
		itemID = id
		SetParent(newParent)
		Return Self
	End Method
	
	
	
	rem
	bbdoc: Event handler
	endrem
	Method OnEvent:Int(event:TEvent)
		If event.source = interact And event.id = EVENT_GADGETLOSTFOCUS
			CreateItemEvent(EVENT_ITEMCHANGED, GadgetText(interact))
			Return True
		EndIf
		Return False
	End Method
	
	
    
	Rem
	bbdoc: Returns string value
	endrem	
	Method GetValue:String()
		Return GadgetText(interact)
	End Method
	
	

	rem
	bbdoc: Sets string value
	about: no commas allowed in strings, as export uses csv.
	endrem
	Method SetValue(value:String)
		value = value.Replace(",", "_")
		SetGadgetText(interact, String(value))
	End Method
	
	
	
	rem
	bbdoc: Filters user input
	endrem	
	Function FilterInput:Int(event:TEvent, context:Object)
		If event.id = EVENT_KEYCHAR
			'no =
			If event.data = 44 Then Return 0
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


