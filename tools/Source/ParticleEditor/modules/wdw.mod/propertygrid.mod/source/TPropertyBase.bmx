

rem
bbdoc: Property grid base item
endrem
Type TPropertyBase Abstract

	Field mainPanel:TGadget
	Field label:TGadget
	
	'item id. passed to events
	Field itemID:Int

	'derived object must have this method
	Method OnEvent:Int(event:TEvent) Abstract
	
	
	
	rem
	bbdoc: Returns item ID
	endrem
	Method GetID:Int()
		Return id
	End Method
	
		
	
	Rem
	bbdoc: Returns main panel
	endrem	
	Method GetPanel:TGadget()
		Return mainPanel
	End Method
	
	
	
	rem
	bbdoc: Sets item tooltip text
	endrem
	Method SetToolTipText(tip:String)
		SetGadgetToolTip(label, tip)
	End Method	
	
	
		
	Rem
	bbdoc: Sets item name
	endrem	
	Method SetName(newName:String)
		SetGadgetText(label, newName)
	End Method
	

	
	rem
	bbdoc: Returns item name
	endrem
	Method GetName:String()
		Return GadgetText(label)
	End Method	
	
		
	
	rem
	bbdoc: Returns vertical size of main panel
	endrem	
	Method GetHeight:Int()
		Return GadgetHeight(mainPanel)
	End Method
		
	
	
	Rem
	bbdoc: Sets main panel vertical position
	endrem	
	Method SetPosition(ypos:Int)
		SetGadgetShape(mainPanel, 0, ypos, GadgetWidth(mainPanel), GadgetHeight(mainPanel))
	End Method
		
	

	rem
	bbdoc: Hides main panel
	endrem
	Method Hide()
		If GadgetHidden(mainPanel) Then Return
		HideGadget(mainPanel)
	End Method
	
	

	Rem
	bbdoc: Returns hidden status of item
	endrem	
	Method GetHidden:Int()
		Return GadgetHidden(mainPanel)
	End Method
	
	

	rem
	bbdoc: Shows main panel
	endrem	
	Method Show()
		If Not GadgetHidden(mainPanel) Then Return
		ShowGadget(mainPanel)
	End Method
	
		

	rem
	bbdoc: Frees item
	endrem		
	Method Free()
		FreeGadget(mainPanel)
		If label Then FreeGadget(label)
	End Method
End Type