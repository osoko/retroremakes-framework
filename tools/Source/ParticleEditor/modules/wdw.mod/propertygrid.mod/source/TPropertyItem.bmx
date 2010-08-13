
'event returned from item event handlers
Global EVENT_ITEMCHANGED:Int = AllocUserEventId("ItemChanged")



rem
bbdoc: All property ITEMS are based on this type.
endrem
Type TPropertyItem Extends TPropertyBase Abstract
	
	'the gadget the user interacts with
	Field interact:TGadget

	'parent group
	Field parent:TPropertyGroup
	
'	Method Clone:TPropertyItem() Abstract
	Method OnEvent(event:TEvent) Abstract
	Method ExportToString:String() Abstract	

		
	
	rem
	bbdoc: Sets parent for this item
	endrem	
	Method SetParent(p:TPropertyGroup)
		parent = p
		parent.AddItem(Self)
	End Method
	
	

	rem
	bbdoc: Returns item parent
	endrem
	Method GetParent:TPropertyGroup()
		Return parent
	End Method
	
	
	
	rem
	bbdoc: Removes item from its parent
	endrem
	Method RemoveParent()
		parent.RemoveItem(Self)
		parent = Null
	End Method
		
	
	
	rem
	bbdoc: Frees item
	endrem
	Method Free()
		FreeGadget interact
		Super.Free()
	End Method
	

	
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
	bbdoc: Puts this item on passed location
	endrem
	Method SetPosition(ypos:Int) Final
		SetGadgetShape(mainPanel, ITEM_INDENT, ypos, GadgetWidth(mainPanel), ITEM_SIZE + 1)
	End Method

	
	
	rem
	bbdoc: Creates the default contents of a property item
	endrem
	Method CreateItemPanel(parent:TPropertyGroup) Final
		mainPanel = CreatePanel(ITEM_INDENT, 0, ClientWidth(parent.mainPanel) - ITEM_INDENT, ITEM_SIZE + 1, parent.mainPanel)
		SetGadgetColor(mainPanel, 255, 255, 255)
		label = CreateLabel("", 2, 4, ClientWidth(mainPanel) - INTERACT_WIDTH - 2, ITEM_SIZE - 8, mainPanel)
	End Method

	
	
	Rem
	bbdoc: Creates a property item event
	about: This is to be caught by your main app event loop.
	Extra contains the value of the interact gadget
	endrem
	Method CreateItemEvent(id:Int, extra:Object)
		Local e:TEvent = New TEvent
		e.id = id
		e.data = itemid
		e.source = Self
		e.extra = extra
		EmitEvent(e)
	End Method
		
End Type