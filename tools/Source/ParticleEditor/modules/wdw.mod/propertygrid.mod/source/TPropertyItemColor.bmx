
Function CreatePropertyItemColor:TPropertyItemColor(label:String, red:Int = 255, green:Int = 255, blue:Int = 255, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemColor.Create(label, red, green, blue, id, parent)
End Function


Type TPropertyItemColor Extends TPropertyItem

	Field colorPanel:TGadget

	Method Create:TPropertyItemColor(newLabel:String, defaultRed:Int, defaultGreen:Int, defaultBlue:Int, id, newParent:TPropertyGroup)

		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(ClientWidth(mainPanel) - INTERACT_WIDTH, 2, INTERACT_WIDTH - 4 - (ITEM_SIZE * 2), ITEM_SIZE - 3, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, String(defaultRed) + "," + String(defaultGreen) + "," + String(defaultBlue))
		SetGadgetFilter(interact, FilterInput)
		SetGadgetToolTip(label, "Enter RGB components or click on color~nto choose a color.")
				
		colorPanel = CreatePanel(ClientWidth(mainPanel) - (ITEM_SIZE * 2) - 2, 2, ITEM_SIZE * 2, ITEM_SIZE - 3, mainPanel, PANEL_BORDER)
		SetGadgetColor(colorPanel, defaultRed, defaultGreen, defaultBlue)
		SetGadgetSensitivity(colorPanel, SENSITIZE_MOUSE)
		SetParent(newParent)
		itemID = id
		Return Self
	End Method
	
	
	
	Rem
	bbdoc: Frees this item
	endrem
	Method Free()
		FreeGadget interact
		FreeGadget colorPanel
	End Method
	

	
	Rem
	bbdoc: Returns red component of color value
	endrem	
	Method GetRed:Int()
		Local array:String[] = GadgetText(interact).Split(",")
		Return Int(array[0])
	End Method


		
	Rem
	bbdoc: Returns green component of color value
	endrem	
	Method GetGreen:Int()
		Local array:String[] = GadgetText(interact).Split(",")
		Return Int(array[1])
	End Method	
	
	

	Rem
	bbdoc: Returns blue component of color value
	endrem	
	Method GetBlue:Int()
		Local array:String[] = GadgetText(interact).Split(",")
		Return Int(array[2])
	End Method
		
	
	
	Rem
	bbdoc: Returns color values in an array
	endrem	
	Method GetColorValue:Int[] ()
		Local array:Int[3]
		array[0] = GetRed()
		array[1] = GetGreen()
		array[2] = GetBlue()
		Return array
	End Method
	
	
	
	Rem
	bbdoc: Sets color values
	endrem	
	Method SetColorValue(r:Int, g:Int, b:Int)
		SetGadgetColor(interact, 0, 0, 0, False)
		SetGadgetText(interact, String(r) + "," + String(g) + "," + String(b))
		SetGadgetColor(colorPanel, r, g, b)
	End Method
	
	
	
	Rem
	bbdoc: Filters user input
	endrem
	Function FilterInput:Int(event:TEvent, context:Object)
		If event.id = EVENT_KEYCHAR

			'allow backspace
			If event.data = 8 Then Return 1

			'allow comma
			If event.data = 44 Then Return 1

			'allow only 0-9
			If event.data < 48 Or event.data > 57 Return 0
		EndIf
		Return 1
	End Function

	
	
	Rem
	bbdoc: Event handler for this item
	endrem
	Method OnEvent:Int(event:TEvent)
	
		'clicked on color box?
		If event.source = colorPanel And event.id = EVENT_MOUSEUP And event.data = 1
			RequestColor(255, 255, 255)

			SetGadgetColor(colorPanel, RequestedRed(), RequestedGreen(), RequestedBlue())
			SetGadgetText(interact, String(RequestedRed()) + "," + String(RequestedGreen()) + "," ..
				+ String(RequestedBlue()))
				
			CreateItemEvent(EVENT_ITEMCHANGED, Self.GetColorValue())
			Return True
		End If

		'changed color in text field?
		If event.source = interact And event.id = EVENT_GADGETLOSTFOCUS
			If GadgetText(interact) = "" Then SetGadgetText(interact, "0,0,0")
			
			Local array:String[] = GadgetText(interact).Split(",")
			
			If array.Length <> 3 Then
				SetGadgetColor(interact, 255, 0, 0, False)
				CreateItemEvent(EVENT_ITEMCHANGED, Self.GetColorValue())
				Return True
			End If
			
			Local newColor:Int[3]
			newColor[0] = Int(array[0])
			newColor[1] = Int(array[1])
			newColor[2] = Int(array[2])
			
			If newColor[0] > 255 Then newColor[0] = 255
			If newColor[1] > 255 Then newColor[1] = 255
			If newColor[2] > 255 Then newColor[2] = 255

			If newColor[0] <= 255 And newColor[1] <= 255 And newColor[2] <= 255 Then
				SetColorValue(newColor[0], newColor[1], newColor[2])
			Else
				'red text if not a correct color value
				SetGadgetColor(interact, 255, 0, 0, False)
				
				'no change event, illegal value
				Return True
			End If
			
			CreateItemEvent(EVENT_ITEMCHANGED, Self.GetColorValue())
			Return True
		EndIf
		
		'not handled
		Return False
	End Method	
	
	
	
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

