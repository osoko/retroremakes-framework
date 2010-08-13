
Function CreatePropertyItemSeparator:TPropertyItemSeparator(label:String, parent:TPropertyGroup)
	Return New TPropertyItemSeparator.Create(label, parent)
End Function


Type TPropertyItemSeparator Extends TPropertyItem

	Method Create:TPropertyItemSeparator(newLabel:String, newParent:TPropertyGroup)
		CreateItemPanel(newParent)
		SetGadgetColor(mainPanel, 225, 225, 225)'245, 245, 245)
		SetGadgetText(label, newLabel)
		SetGadgetFont(label, LookupGuiFont(GUIFONT_SYSTEM, 0, FONT_BOLD))
		SetGadgetTextColor(label, 100, 100, 100)'225, 225, 225)

		SetParent(newParent)
		Return Self
	End Method
	
	Rem
	bbdoc: Frees this item
	endrem
	Method Free()
	End Method

	
		
	rem
	bbdoc: Event handler
	endrem
	Method OnEvent:Int(event:TEvent)
		'nothing to handle
		Return False
	End Method
	
	
	
	rem
	bbdoc: Exports string item to string
	endrem
	Method ExportToString:String()
		Return "parameter,separator," + GadgetText(label)' + "," + GadgetText(interact)
	End Method	

	
	
	Method Clone:TPropertyItem()
		Return New TPropertyItemSeparator.Create(Self.GetName(), Self.GetParent())
	End Method
	
End Type


