
Function CreatePropertyItemBool:TPropertyItemBool(label:String, value:Int = 1, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemBool.Create(label, value, id, parent)
End Function


Type TPropertyItemBool Extends TPropertyItem

	Method Create:TPropertyItemBool(newLabel:String, defaultValue:Int, id:Int, newParent:TPropertyGroup)

		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)
		
		interact = CreateButton("", ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - 1, ITEM_SIZE - 3, mainPanel, BUTTON_CHECKBOX)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetButtonState(interact, defaultValue)
		UpdateBoolText()
		itemID = id
		SetParent(newParent)
		Return Self
	End Method
	
	
	
	rem
	bbdoc: Event handler for this item
	endrem
	Method OnEvent:Int(event:TEvent)
		If event.source = interact And event.id = EVENT_GADGETACTION
			UpdateBoolText()
			CreateItemEvent(EVENT_ITEMCHANGED, GadgetText(interact))
			Return True
		EndIf
		Return False
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

