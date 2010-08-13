
Function CreatePropertyItemPath:TPropertyItemPath(label:String, value:String = "", id:Int, parent:TPropertyGroup)
	Return New TPropertyItemPath.Create(label, value, id, parent)
End Function


Type TPropertyItemPath Extends TPropertyItem

	Global folderIcon:TPixmap = LoadPixmap("incbin::media/folder.bmp")

	Field selectorText:String
	Field selectorFilter:String
	Field folderPanel:TGadget

	Method Create:TPropertyItemPath(newLabel:String, defaultValue:String, id, newParent:TPropertyGroup)

		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - ITEM_SIZE, ITEM_SIZE - 3, mainPanel)
		'interact = CreateTextField(ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - 1, ITEM_SIZE - 3, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		DisableGadget(interact)
		
		folderPanel = CreatePanel(ClientWidth(mainPanel) - ITEM_SIZE + 2, 2, ITEM_INDENT, ITEM_SIZe - 2, mainPanel)
		SetGadgetLayout(folderPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetColor(folderPanel, 255, 0, 0)
		SetGadgetPixmap(folderPanel, folderIcon, PANELPIXMAP_STRETCH)
		SetGadgetSensitivity(folderPanel, SENSITIZE_MOUSE)
		
		selectorText = "Select file..."
		selectorFilter = "*Image Files:png,jpg,bmp;Text Files:txt;All Files:*"
		itemID = id
		SetParent(newParent)
		Return Self
	End Method
	
	
	
	Method SetFilterText(text:String)
		selectorFilter = text
	End Method
	
	Method SetSelectorText(text:String)
		selectorText = text
	End Method
	
	
	
	Rem
	bbdoc: Frees this item
	endrem
	Method Free()
		FreeGadget folderPanel
	End Method

	
		
	rem
	bbdoc: Event handler
	endrem
	Method OnEvent:Int(event:TEvent)
		If event.source = folderPanel And event.id = EVENT_MOUSEUP And event.data = 1
			Local path:String = RequestFile(selectorText, selectorFilter, False)
			If path <> ""
				SetGadgetText(interact, path)
				CreateItemEvent(EVENT_ITEMCHANGED, GadgetText(interact))
				Return True
			EndIf
		End If	

		'not handled
		Return False
	End Method
	
	
	
	Rem
	bbdoc: Returns file path value as string
	endrem	
	Method GetValue:String()
		Return GadgetText(interact)
	End Method
	
	

	rem
	bbdoc: Sets file path string value
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
			'no commas
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
'		Return New TPropertyItemPath.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'	End Method
	
End Type


