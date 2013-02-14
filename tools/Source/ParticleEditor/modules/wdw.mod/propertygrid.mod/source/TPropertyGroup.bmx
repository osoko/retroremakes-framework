
Function CreatePropertyGroup:TPropertyGroup(label:String, id:Int, parent:Object)
	Return New TPropertyGroup.Create(label, id, parent)
End Function


Type TPropertyGroup Extends TPropertyBase

	Field titleIcon:TGadget
	Field labelPanel:TGadget
	
	Field itemList:TList
	Field collapsed:Int
	Field hidden:Int
	
	'mouse hit on label flag
	Field hit:Int
	
	Global barIcon1:TPixmap = LoadPixmap("incbin::media/header.bmp")		'closed
	Global barIcon2:TPixmap = LoadPixmap("incbin::media/header2.bmp")		'open

	
		
	Method Create:TPropertyGroup(title:String, id:Int, parent:Object)
	
		itemList = New TList
		collapsed = False
		hidden = False
		itemIndent = 0
		
		Local tmpPanel:TGadget
		If TPropertyGrid(parent) Then
			tmpPanel = TPropertyGrid(parent).GetPanel()
			itemIndent = 0
		EndIf

		If TPropertyGroup(parent) Then
			tmpPanel = TPropertyGroup(parent).GetPanel()
			itemIndent = TPropertyGroup(parent).GetItemIndent() + ITEM_INDENT_SIZE
		EndIf
		
		mainPanel = CreatePanel(0, 0, ClientWidth(tmpPanel), ITEM_SIZE, tmpPanel)
		SetGadgetLayout(mainPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetColor(mainPanel, 225, 225, 225)
		
		titleIcon = CreatePanel(4, 2, ITEM_INDENT_SIZE, ITEM_SIZE - 4, mainPanel)
		SetGadgetLayout(titleIcon, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetPixmap(titleIcon, barIcon2, PANELPIXMAP_CENTER)
		
		labelPanel = CreatePanel(ITEM_SIZE, 0, ClientWidth(mainPanel) - ITEM_SIZE, ITEM_SIZE, mainPanel)
		SetGadgetLayout(labelPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
				
		Local labelX:Int = 2 + itemIndent - ITEM_INDENT_SIZE
		If itemIndent = 0 Then labelX = 0
		label = CreateLabel(title, labelX, 3, ClientWidth(labelPanel) - labelX, ITEM_SIZE - 3, labelPanel)
		SetGadgetLayout(label, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetFont(label, LookupGuiFont(GUIFONT_SYSTEM, 0, FONT_BOLD))
		SetGadgetTextColor(label, 100, 100, 100)
		SetGadgetSensitivity(label, SENSITIZE_MOUSE)
		
		SetItemID(id)

		If TPropertyGrid(parent)
			SetGadgetColor(labelPanel, 225, 225, 225)
			TPropertyGrid(parent).AddGroup(Self)
		ElseIf TPropertyGroup(parent)
			SetGadgetColor(labelPanel, 255, 255, 255)
			TPropertyGroup(parent).AddItem(Self)
		EndIf
				
		AddHook(EmitEventHook, eventHandler, Self, -1)
		
		Return Self
	End Method
	
	
	
	Rem
	bbdoc: Opens or closes group
	endrem
	Method Toggle()
		
		collapsed = Not collapsed
		If collapsed
			SetGadgetPixmap(titleIcon, barIcon1, PANELPIXMAP_CENTER)
			SetGadgetShape(mainPanel, GadgetX(mainPanel), GadgetY(mainPanel), GadgetWidth(mainPanel), ITEM_SIZE)
		Else
			SetGadgetPixmap(titleIcon, barIcon2, PANELPIXMAP_CENTER)
		End If
		
		EmitEvent CreateEvent(EVENT_PG_GROUPTOGGLE, Self, itemID)
	End Method
	
	
	
	Method Refresh()
		Local ypos:Int = ITEM_SIZE + ITEM_SPACING

		'arrange items on group
		For Local g:TPropertyBase = EachIn itemList
			If TPropertyGroup(g)
				TPropertyGroup(g).Refresh()
				TPropertyGroup(g).SetVerticalPosition(ypos)
				ypos:+TPropertyGroup(g).GetHeight()
			Else
				g.SetVerticalPosition(ypos)
				ypos:+g.GetHeight() + ITEM_SPACING
			End If
		Next
		
		'fit group. ypos is now the total size
		If collapsed Then ypos = ITEM_SIZE + ITEM_SPACING
		SetGadgetShape(mainPanel, 0, 0, GadgetWidth(mainPanel), ypos)
	End Method
	
	
	
	Rem
	bbdoc: Sets vertical position
	about: overrides TPropertyBase.SetVerticalPosition
	endrem	
	Method SetVerticalPosition(ypos:Int)
		SetGadgetShape(mainPanel, 0, ypos, GadgetWidth(mainPanel), GadgetHeight(mainPanel))
	End Method
		
	
	
	Rem
	bbdoc: Returns y-size of group panel, or no size when group is hidden
	about: Overrides TPropertyBase.getheight()
	endrem
	Method GetHeight:Int()
		If GadgetHidden(mainPanel) Then Return 0
		If collapsed Then Return ITEM_SIZE
		Return GadgetHeight(mainPanel)
	End Method

	
	
	Rem
	bbdoc: Returns a list containing the group items
	endrem
	Method GetItems:TList()
		Return itemList
	End Method	
	
	
	
	Rem
	bbdoc: Adds an item to the group
	endrem	
	Method AddItem(i:TPropertyBase)
		itemList.AddLast(i)
	End Method
	

	
	Rem
	bbdoc: Frees property group and its items
	endrem	
	Method CleanUp()
	
'		For Local i:TPropertyItemBase = EachIn itemList
'			i.CleanUp()
'		Next
		itemList.Clear()	

		FreeGadget titleIcon
		FreeGadget label
		FreeGadget labelPanel
	End Method
	
	
	
	rem
	bbdoc: Hides group
	endrem
	Method Hide()
		If GadgetHidden(mainPanel) Then Return
		HideGadget(mainPanel)
		EmitEvent CreateEvent(EVENT_PG_GROUPVISIBLE, Self, itemID)
	End Method
	
	
	
	rem
	bbdoc: Shows group
	endrem	
	Method Show()
		If Not GadgetHidden(mainPanel) Then Return
		ShowGadget(mainPanel)
		EmitEvent CreateEvent(EVENT_PG_GROUPVISIBLE, Self, itemID)
	End Method
	
	

	Rem
	bbdoc: Returns hidden status of item
	endrem	
	Method GetHidden:Int()
		Return GadgetHidden(mainPanel)
	End Method

	

	Rem
	bbdoc: Deletes item
	endrem	
'	Method DeleteItemByLabel(label:String)
'		For Local i:TPropertyItemBase = EachIn itemList
'			If GadgetText(i.label) = label
'				i.CleanUp()
'				itemList.Remove(i)
'				Return
'			EndIf
'		Next
'	End Method
	
	Rem
	bbdoc: Hides all items on the group
	endrem	
'	Method HideItems()
'		For Local i:TPropertyItem = EachIn itemList
'			i.Hide()
'		Next		
'	End Method
	
	

	Rem
	bbdoc: Shows all items on the group
	endrem
'	Method ShowItems()
'		For Local i:TPropertyItem = EachIn itemList
'			i.Show()
'		Next
'	End Method
	

	Rem
	bbdoc: Sets path value by item name
	endrem	
	Method SetPathByLabel(label:String, newValue:String)
		For Local i:TPropertyItemPath = EachIn itemList
			If i.GetLabel().ToLower() = label.ToLower()
				i.SetValue(newValue)
				Return
			End If
		Next
	End Method
	

	
	Rem
	bbdoc: Returns path value by item name
	endrem	
	Method GetPathByLabel:String(label:String)
		For Local i:TPropertyItemPath = EachIn itemList
			If i.GetLabel().ToLower() = label.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets string value by item name
	endrem	
	Method SetStringByLabel(label:String, newValue:String)
		For Local i:TPropertyItemString = EachIn itemList
			If i.GetLabel().ToLower() = label.ToLower()
				i.SetValue(newValue)
				Return
			End If
		Next
	End Method
	

	
	Rem
	bbdoc: Returns string value by item name
	endrem	
	Method GetStringByLabel:String(label:String)
		For Local i:TPropertyItemString = EachIn itemList
			If i.GetLabel().ToLower() = label.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method	
	
			
	
	Rem
	bbdoc: Sets int value by item name
	endrem	
	Method SetIntByLabel(name:String, newValue:Int)
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
	Method GetIntByLabel:Int(name:String)
		For Local i:TPropertyItemInt = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets float value by item name
	endrem	
	Method SetFloatByLabel(name:String, newValue:Float)
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
	Method GetFloatByLabel:Float(name:String)
		For Local i:TPropertyItemFloat = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
		
	Rem
	bbdoc: Sets color value by item name
	endrem	
	Method SetColorByLabel(name:String, r:Int, g:Int, b:Int)
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
	Method GetColorByLabel:Int[] (name:String)
		For Local i:TPropertyItemColor = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
'				Return i.GetColorValue()
			End If
		Next
	End Method
	
	
		
	Rem
	bbdoc: Sets boolean value by item name
	endrem	
	Method SetBoolByLabel(name:String, bool:Int)
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
	Method GetBoolByLabel:Int(name:String)
		For Local i:TPropertyItemBool = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.GetValue()
			End If
		Next
	End Method
	
	
		
	Rem
	bbdoc: Sets choice value by item name
	endrem	
	Method SetChoiceByLabel(name:String, index:Int)
		For Local i:TPropertyItemChoice = EachIn itemList
			If GadgetText(i.label) = name
				i.SetIndexValue(index)
				Return
			End If
		Next
	End Method

	
	
	Rem
	bbdoc: Gets choice index by item name
	endrem	
	Method GetChoiceByLabel:Int(name:String)
		For Local i:TPropertyItemChoice = EachIn itemList
			If GadgetText(i.label).ToLower() = name.ToLower()
				Return i.getValue()
			End If
		Next
	End Method
	

	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpPropertyGroup:TPropertyGroup = TPropertyGroup(context)
		If tmpPropertyGroup Then data = tmpPropertyGroup.eventHook(id, data, context)
		Return data
	End Function
	
	
	
	Method eventHook:Object(id:Int, data:Object, context:Object)
	
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.source
			Case label
				Select tmpEvent.id
					Case EVENT_MOUSEENTER
						SetGadgetTextColor(label, 0, 0, 0)
						hit = False
						
					Case EVENT_MOUSELEAVE
						SetGadgetTextColor (label, 100, 100, 100)
						hit = False
					
					Case EVENT_MOUSEDOWN
						If tmpEvent.data = 1 Then hit = True
					
					Case EVENT_MOUSEUP
						If tmpEvent.data = 1 And hit = True Then Toggle()
						
					Default
						'it is an event from this label we're not interested in.
						Return data
				End Select
				
				'label handled, so get rid of old data
				data = Null
				
				'create an event
				'EmitEvent CreateEvent(EVENT_GADGETACTION, Self, GetItemID())
				
			Default
				'no event for this group
				Return data
		End Select

		Return data
	End Method	

End Type
