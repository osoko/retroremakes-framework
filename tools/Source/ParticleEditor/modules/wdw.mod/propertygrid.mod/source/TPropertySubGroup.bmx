

Type TPropertySubGroup Extends TPropertyGroup
	
	Method Create:TPropertySubGroup(title:String, id:Int, parent:Object, autoAdd:Int = True)
		itemList = New TList
		collapsed = False
		hidden = False
		
		Local parentPanel:TGadget
		parentPanel = TPropertyGroup(parent).GetPanel()
	
		mainPanel = CreatePanel(ITEM_INDENT, 0, ClientWidth(parentPanel) - ITEM_INDENT,  ..
			ITEM_SIZE + ITEM_SPACING, parentPanel)
		SetGadgetLayout(mainPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetColor(mainPanel, 225, 225, 225)
		
		titleIcon = CreatePanel(1, 1, ITEM_INDENT - 2, ITEM_SIZE - 2, mainPanel)
		SetGadgetLayout(titleIcon, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetPixmap(titleIcon, barIcon2, PANELPIXMAP_CENTER)
		
		label = CreateLabel(title, ITEM_INDENT + 2, 3, ClientWidth(mainPanel) - (ITEM_INDENT + 2), ITEM_SIZE - 3, mainPanel)
		SetGadgetFont(label, LookupGuiFont(GUIFONT_SYSTEM, 0, FONT_BOLD))
		SetGadgetTextColor(label, 100, 100, 100)
		SetGadgetLayout(label, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetSensitivity(label, SENSITIZE_MOUSE)

		If autoAdd Then TPropertyGroup(parent).AddItem(Self)
		itemID = id
		Return Self
	End Method

	

	Rem
	bbdoc: Sets main panel vertical position
	about: override to force group to the right	
	endrem	
	Method SetPosition(ypos:Int)
		SetGadgetShape(mainPanel, ITEM_INDENT, ypos, GadgetWidth(mainPanel), GadgetHeight(mainPanel))
	End Method

End Type
