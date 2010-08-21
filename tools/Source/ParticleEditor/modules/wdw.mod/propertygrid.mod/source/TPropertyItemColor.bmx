
Function CreatePropertyItemColor:TPropertyItemColor(label:String, red:Int = 255, green:Int = 255, blue:Int = 255, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemColor.Create(label, red, green, blue, id, parent)
End Function


Type TPropertyItemColor Extends TPropertyItem

	Field colorLabel:TGadget
	Field r:Int, g:Int, b:Int

	Method Create:TPropertyItemColor(newLabel:String, defaultRed:Int, defaultGreen:Int, defaultBlue:Int, id:Int, newParent:TPropertyGroup)
		
		itemID = id
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)
		
'		Local xpos:Int = ClientWidth(mainPanel) - INTERACT_WIDTH
		interact = CreatePanel(interactX, 2, ITEM_SIZE, ITEM_SIZE - 3, mainPanel, PANEL_BORDER)
		SetGadgetSensitivity(interact, SENSITIZE_MOUSE)

		colorLabel = CreateLabel("", interactX + ITEM_SIZE + 4, 3, ClientWidth(mainPanel) - ITEM_SIZE - 4, ITEM_SIZE, mainPanel)
		SetGadgetLayout(colorLabel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)

		SetColorValue(defaultRed, defaultGreen, defaultBlue)
		
		AddHook(EmitEventHook, eventHandler, Self, 0)
		newParent.AddItem(Self)

		Return Self
	End Method
	
	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemColor = TPropertyItemColor(context)
		If tmpItem Then data = tmpItem.eventHook(id, data, context)
		Return data
	End Function
	
	

	Method eventHook:Object(id:Int, data:Object, context:Object)
	
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.source
			Case interact
				Select tmpEvent.id
					Case EVENT_MOUSEUP					
						If tmpEvent.data = 1
							If RequestColor(r, g, b)
								SetColorValue(RequestedRed(), RequestedGreen(), RequestedBlue())
							EndIf
						End If
						CreateItemEvent(EVENT_PG_ITEMCHANGED, Self.GetColorValue())
						
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
	bbdoc: Frees this item
	endrem
	Method Free()
		FreeGadget interact
		FreeGadget colorLabel
	End Method
	

	
	Rem
	bbdoc: Returns red component of color value
	endrem	
	Method GetRed:Int()
		Return r
	End Method


		
	Rem
	bbdoc: Returns green component of color value
	endrem	
	Method GetGreen:Int()
		Return g
	End Method	
	
	

	Rem
	bbdoc: Returns blue component of color value
	endrem	
	Method GetBlue:Int()
		Return b
	End Method
		
	
	
	Rem
	bbdoc: Returns color values in an array
	endrem	
	Method GetColorValue:Int[] ()
		Local array:Int[3]
		array[0] = r
		array[1] = g
		array[2] = b
		Return array
	End Method
	
	
	
	Rem
	bbdoc: Sets color values
	endrem	
	Method SetColorValue(red:Int, green:Int, blue:Int)
		r = red
		g = green
		b = blue
		SetGadgetColor(interact, r, g, b)
		SetGadgetText(colorLabel, "(" + String(r) + "," + String(g) + "," + String(b) + ")")
	End Method
	
	
	
	Rem
	bbdoc: Filters user input
	endrem
	Function FilterInput:Int(event:TEvent, context:Object)
'		If event.id = EVENT_KEYCHAR

			'allow backspace
'			If event.data = 8 Then Return 1

			'allow comma
'			If event.data = 44 Then Return 1

			'allow only 0-9
'			If event.data < 48 Or event.data > 57 Return 0
'		EndIf
		Return 1
	End Function

	
	

	
	
	
	Rem
	bbdoc: Exports the color values to a csv string
	endrem	
	Method ExportToString:String()
		Return "parameter,color," + GadgetText(label) + "," + GadgetText(interact)
	End Method
	
	
	
'	Method Clone:TPropertyItem()
'		Local s:TPropertyItemColor = New TPropertyItemColor.Create(Self.GetName(),  ..
'			Self.GetRed(), Self.GetGreen(), Self.GetBlue(), Self.GetParent())
'		Return s
'	End Method
	
End Type

