
rem
bbdoc: All property items are derived from this type
endrem
Type TPropertyItem Extends TPropertyBase Abstract

	'the gadget the user interacts with
	Field interact:TGadget
	
	'fixed position of interact gadget
	Global interactX:Int = GRID_WIDTH - INTERACT_WIDTH - SLIDER_WIDTH - ITEM_SIZE
	

	
	rem
	bbdoc: Sets interact gadget readonly value
	endrem	
	Method SetReadOnly(value:Int)
		If value
			DisableGadget(interact)
		Else
			EnableGadget(interact)
		End If
	End Method

	
	
	rem
	bbdoc: Creates the default contents of a property item
	endrem
	Method CreateItemPanel(parent:TPropertyGroup) Final

		itemIndent = parent.GetItemIndent()
		Local parentPanel:TGadget = parent.GetPanel()
		
		mainPanel = CreatePanel(ITEM_SIZE, 0, ClientWidth(parentPanel) - ITEM_SIZE, ITEM_SIZE, parentPanel)
		SetGadgetLayout(mainPanel, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetColor(mainPanel, 255, 255, 255)
'		SetGadgetColor(mainPanel, 255, 255, 0)
		label = CreateLabel("", itemIndent + 2, 4, ClientWidth(mainPanel) - INTERACT_WIDTH - itemIndent - SLIDER_WIDTH - 4, ITEM_SIZE - 6, mainPanel)
'		SetGadgetColor(label, 255, 0, 0)
	End Method

	
	
	Rem
	bbdoc: Creates a property item event
	about: This is to be caught by your main app event loop.
	endrem
	Method CreateItemEvent(id:Int, extra:Object)
		EmitEvent CreateEvent(id, Self, idemID, 0, 0, 0, extra)
	End Method
		
End Type