
rem
bbdoc: Items and groups are derived from this type
endrem
Type TPropertyBase Abstract

	Field itemID:Int

	Field mainPanel:TGadget
	
	Field label:TGadget
	
	Field itemIndent:Int
	
	
	
	rem
	bbdoc: Returns main panel
	endrem	
	Method GetPanel:TGadget()
		Return mainPanel
	End Method
		
	
	
	Rem
	bbdoc: Sets item label
	EndRem
	Method SetLabel(value:String)
		SetGadgetText(label, value)
	End Method



	rem
	bbdoc: Returns item name
	endrem
	Method GetLabel:String()
		Return GadgetText(label)
	End Method
	
	
	
	rem
	bbdoc: Sets indent level
	endrem
	Method SetItemIndent(value:Int)
		itemIndent = value
	End Method
		
		
	rem
	bbdoc: Returns indent level
	endrem	
	Method GetItemIndent:Int()
		Return itemIndent
	End Method	
	
	
	
	rem
	bbdoc: Returns vertical size
	endrem	
	Method GetHeight:Int()
		Return GadgetHeight(mainPanel)
	End Method
	
	
	
	Rem
	bbdoc: Sets vertical position
	endrem	
	Method SetVerticalPosition(ypos:Int)
'		Print "setting item '" + GadgetText(label) + "' to ypos: " + ypos
		
		SetGadgetShape(mainPanel, ITEM_SIZE, ypos, GadgetWidth(mainPanel), GadgetHeight(mainPanel))
	End Method
	
	
	
	rem
	bbdoc: Returns item ID
	EndRem
	Method GetItemID:Int()
		Return itemID
	End Method
	
	
	
	rem
	bbdoc: Sets item ID
	endrem
	Method SetItemID(value:Int)
		itemID = value
	End Method
		
End Type