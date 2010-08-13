
'some sizing
Const ITEM_INDENT:Int = 16
Const ITEM_SIZE:Int = 23
Const ITEM_SPACING:Int = 0
Global INTERACT_WIDTH:Int = 0



Rem
bbdoc: Creates a property group on grid, or another group
about: Default is auto-add to propertygrid
EndRem
Function CreatePropertyGroup:TPropertyGroup(title:String, id:Int, parent:Object, autoAdd:Int = True)
	If TPropertyGrid(parent) Then Return New TPropertyGroup.Create(title, id, parent, autoAdd)
	If TPropertyGroup(parent) Then Return New TPropertySubGroup.Create(title, id, parent, autoAdd)
	If TPropertySubGroup(parent) Then Throw "sub group in sub group not supported!"
End Function



Type TPropertyGroup Extends TPropertyBase

	Field titleIcon:TGadget
	
	Field itemList:TList
	Field collapsed:Int
	
	Global barIcon1:TPixmap = LoadPixmap("incbin::media/header.bmp")		'closed
	Global barIcon2:TPixmap = LoadPixmap("incbin::media/header2.bmp")		'open
	
		
	
	Method Create:TPropertyGroup(title:String, id:Int, parent:Object, autoAdd:Int)
		itemList = New TList
		collapsed = False
		hidden = False
		
		Local parentPanel:TGadget
		parentPanel = TPropertyGrid.GetInstance().GetPanel()
	
		mainPanel = CreatePanel(0, 0, ClientWidth(parentPanel), ITEM_SIZE + ITEM_SPACING, parentPanel)
		SetGadgetLayout(mainPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetColor(mainPanel, 225, 225, 225)
		
		titleIcon = CreatePanel(0, 2, ITEM_INDENT, ITEM_SIZE - 4, mainPanel)
		SetGadgetLayout(titleIcon, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetPixmap(titleIcon, barIcon2, PANELPIXMAP_CENTER)
		
		label = CreateLabel(title, ITEM_INDENT + 2, 3, ClientWidth(mainPanel) - (ITEM_INDENT + 2), ITEM_SIZE - 3, mainPanel)
		SetGadgetFont(label, LookupGuiFont(GUIFONT_SYSTEM, 0, FONT_BOLD))
		SetGadgetTextColor(label, 100, 100, 100)
		SetGadgetLayout(label, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetSensitivity(label, SENSITIZE_MOUSE)

		If autoAdd Then TPropertyGrid.GetInstance().AddGroup(Self)
		itemID = id
		Return Self
	End Method
	
	
	
	rem
	bbdoc: Clones this property group
	endrem	
'	Method Clone:TPropertyGroup(autoAdd:Int = True)
'		Local g:TPropertyGroup = New TPropertyGroup.Create(Self.GetName(), Self, autoAdd)
'		For Local i:TPropertyItem = EachIn Self.itemList
'			i.Clone()
'		Next
'		Return g
'	End Method
	
	
	
	Rem
	bbdoc: Opens or closes group
	endrem
	Method Toggle()
		collapsed = Not collapsed
		If collapsed
'			HideItems()
			SetGadgetPixmap(titleIcon, barIcon1, PANELPIXMAP_CENTER)
		Else
'			ShowItems()
			SetGadgetPixmap(titleIcon, barIcon2, PANELPIXMAP_CENTER)
		End If
		
	
	End Method
	
		
	
	Rem
	bbdoc: Resizes group and rearranges items
	endrem	
	Method DoLayout()
		'set main group panel size
		SetSize()
		
		'arrange items on group panel
		Local ypos:Int = ITEM_SIZE
		For Local i:TPropertyBase = EachIn itemList
			i.SetPosition(ypos)
			ypos:+i.GetHeight() + ITEM_SPACING
		Next
	End Method

	
	
	Rem
	bbdoc: Sets vertical size of group panel
	EndRem
	Method SetSize()
		SetGadgetShape(mainPanel, 0, 0, GadgetWidth(mainPanel), CalculateSize())
	End Method
	
	
	
	rem
	bbdoc: Calculates and returns the group size
	endrem	
	Method CalculateSize:Int()
		Local itemsSize:Int = ITEM_SIZE
		If Not collapsed
			For Local item:TPropertyBase = EachIn itemList
			
				If TPropertySubGroup(item)
					itemsSize:+TPropertySubGroup(item).CalculateSize()
				Else
					itemsSize:+item.GetHeight() + ITEM_SPACING
				End If
			Next
		EndIf
		Return itemsSize
	End Method
	
	
	
	Rem
	bbdoc: Returns y-size of group panel, or no size when hidden
	about: Overrides super.setheight()
	endrem
	Method GetHeight:Int()
		If GadgetHidden(mainPanel) Then Return 0
		Return GadgetHeight(mainPanel)
	End Method	
	
	
	
	Rem
	bbdoc: Adds an item to the group
	endrem	
	Method AddItem(i:Object)
		itemList.AddLast(i)
		DoLayout()
	End Method
	
	
	
	rem
	bbdoc: Removes an item from the group
	endrem
	Method RemoveItem(i:TPropertyItem)
		itemList.Remove(i)
		DoLayout()
	End Method
	
	

	Rem
	bbdoc: Returns a list containing the group items
	returns: TList
	endrem
	Method GetItems:TList()
		Return itemList
	End Method
		

		
	Rem
	bbdoc: Deletes item
	endrem	
	Method DeleteItemByLabel(label:String)
		For Local i:TPropertyItem = EachIn itemList
			If GadgetText(i.label) = label
				i.Free()
				itemList.Remove(i)
				Return
			EndIf
		Next
	End Method
	
	
	
	Rem
	bbdoc: Removes and deletes all items from group
	endrem		
	Method DeleteAllItems()
		For Local i:TPropertyItem = EachIn itemList
			i.Free()
		Next
		itemList.Clear()
	End Method
	
	
	
	Rem
	bbdoc: Frees property group
	endrem	
	Method Free()
		DeleteAllItems()
		FreeGadget titleIcon
		Super.Free()
	End Method
	
	
	
	Rem
	bbdoc: Hides all items on the group
	endrem	
	Method HideItems()
		For Local i:TPropertyItem = EachIn itemList
			i.Hide()
		Next		
	End Method
	
	

	Rem
	bbdoc: Shows all items on the group
	endrem
	Method ShowItems()
		For Local i:TPropertyItem = EachIn itemList
			i.Show()
		Next
	End Method
	
		
	
	Rem
	bbdoc: Sets string value by item name
	endrem	
	Method SetStringByName(name:String, newValue:String)
		For Local i:TPropertyItemString = EachIn itemList
			If GadgetText(i.label) = name
				i.SetValue(newValue)
				Return
			End If
		Next
	End Method
	

	
	Rem
	bbdoc: Returns string value by item name
	endrem	
	Method GetStringByName:String(name:String)
		For Local i:TPropertyItemString = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method	
	
			
	
	Rem
	bbdoc: Sets int value by item name
	endrem	
	Method SetIntByName(name:String, newValue:Int)
		For Local i:TPropertyItemInt = EachIn itemList
			If GadgetText(i.label) = name
				i.setvalue(newValue)
				Return
			End If
		Next
	End Method
	

	
	Rem
	bbdoc: Returns int value by item name
	endrem	
	Method GetIntByName:Int(name:String)
		For Local i:TPropertyItemInt = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets float value by item name
	endrem	
	Method SetFloatByName(name:String, newValue:Float)
		For Local i:TPropertyItemFloat = EachIn itemList
			If GadgetText(i.label) = name
				i.setvalue(newValue)
				Return
			End If
		Next
	End Method	

	

	Rem
	bbdoc: Returns float value by item name
	endrem	
	Method GetFloatByName:Float(name:String)
		For Local i:TPropertyItemFloat = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
		
	Rem
	bbdoc: Sets color value by item name
	endrem	
	Method SetColorByName(name:String, r:Int, g:Int, b:Int)
		For Local i:TPropertyItemColor = EachIn itemList
			If GadgetText(i.label) = name
				'SetGadgetText(i.interact, i.FloatToString(newValue))
				Return
			End If
		Next
	End Method
	


	Rem
	bbdoc: Returns color value by item name
	endrem	
	Method GetColorByName:Int[] (name:String)
		For Local i:TPropertyItemColor = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
'				Return i.GetColorValue()
			End If
		Next
	End Method
	
	
		
	Rem
	bbdoc: Sets boolean value by item name
	endrem	
	Method SetBoolByName(name:String, bool:Int)
		For Local i:TPropertyItemBool = EachIn itemList
			If GadgetText(i.label) = name
				i.SetValue(bool)
				Return
			End If
		Next
	End Method
	

	
	Rem
	bbdoc: Returns boolean value by item name
	endrem	
	Method GetBoolByName:Int(name:String)
		For Local i:TPropertyItemBool = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
		
	Rem
	bbdoc: Sets choice value by item name
	endrem	
	Method SetChoiceByName(name:String, index:Int)
		For Local i:TPropertyItemChoice = EachIn itemList
			If GadgetText(i.label) = name
				i.SetIndexValue(index)
				Return
			End If
		Next
	End Method

	
	
	Rem
	bbdoc: Gets choice value by item name
	endrem	
	Method GetChoiceByName:Int(name:String, index:Int)
		For Local i:TPropertyItemChoice = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.getValue()
			End If
		Next
	End Method
	
	

	Rem
	bbdoc: Handles events for this group and its items
	endrem	
	Method OnEvent:Int(event:TEvent)
		If event.source = label
			Select event.id
				Case EVENT_MOUSEENTER
					SetGadgetTextColor(label, 0, 0, 0)
					'handled
					Return True
		
				Case EVENT_MOUSELEAVE
					SetGadgetTextColor (label, 100, 100, 100)
					'handled
					Return True
					
				Case EVENT_MOUSEDOWN
					
				Case EVENT_MOUSEUP
					If event.data = 1
						Toggle()
						TPropertyGrid.GetInstance().DoLayout()
						'handled
						Return True
					End If
			End Select
		Else
			For Local item:TPropertyBase = EachIn itemList
				result = item.OnEvent(event)
				
				'handled
				If result = True Then Return True
			Next
		EndIf
		Return False
	End Method
	

End Type
