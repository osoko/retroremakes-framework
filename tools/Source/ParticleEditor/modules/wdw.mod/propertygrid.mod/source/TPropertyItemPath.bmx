
Function CreatePropertyItemPath:TPropertyItemPath(label:String, value:String = "", id:Int, parent:TPropertyGroup)
	Return New TPropertyItemPath.Create(label, value, id, parent)
End Function



Type TPropertyItemPath Extends TPropertyItem

	Global folderIcon:TPixmap = LoadPixmap("incbin::media/folder.bmp")

	'mouse hit on folder panel
	Field hit:Int
	
	Field selectorText:String
	Field selectorFilter:String
	Field folderPanel:TGadget

	Method Create:TPropertyItemPath(newLabel:String, defaultValue:String, id:Int, newParent:TPropertyGroup)

		itemID = id
	
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(interactX, 1, INTERACT_WIDTH - ITEM_SIZE, ITEM_SIZE - 2, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		DisableGadget(interact)
		
		Local xpos:Int = GadgetX(interact) + GadgetWidth(interact)
		folderPanel = CreatePanel(xpos, 1, ITEM_SIZE, ITEM_SIZE - 2, mainPanel)
		
		SetGadgetLayout(folderPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetColor(folderPanel, 255, 0, 0)
		SetGadgetPixmap(folderPanel, folderIcon, PANELPIXMAP_STRETCH)
		SetGadgetSensitivity(folderPanel, SENSITIZE_MOUSE)
		
		selectorText = "Select file..."
		selectorFilter = "*Image Files:png,jpg,bmp;Text Files:txt;All Files:*"

		AddHook(EmitEventHook, eventHandler, Self, 0)
		
		newParent.AddItem(Self)
		
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

	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemPath = TPropertyItemPath(context)
		If tmpItem Then data = tmpItem.eventHook(id, data, context)
		Return data
	End Function

	
	
	Method eventHook:Object(id:Int, data:Object, context:Object)
	
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.source
			Case folderPanel
				Select tmpEvent.id
					Case EVENT_MOUSEUP
						If tmpEvent.data = 1
						
							Local path:String = RequestFile(selectorText, selectorFilter, False, AppDir)
						
							If path <> ""
								SetGadgetText(interact, path)
								CreateItemEvent(EVENT_ITEMCHANGED, GadgetText(interact))
							EndIf
						EndIf
						
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
	bbdoc: Returns file path value as string
	endrem	
	Method GetValue:String()
		Return GadgetText(interact)
	End Method
	
	

	rem
	bbdoc: Sets file path string value
	endrem
	Method SetValue(value:String)
		value = value.Replace("\", "/").Trim()
'		value.Trim()
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
'	Method ExportToString:String()
'		Return "parameter,string," + GadgetText(label) + "," + GadgetText(interact)
'	End Method
'	Method Clone:TPropertyItem()
'		Return New TPropertyItemPath.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'	End Method
	
End Type


