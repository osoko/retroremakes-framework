
Function CreatePropertyItemFloat:TPropertyItemFloat(label:String, value:Float = 1.0, id:Int, parent:TPropertyGroup)
	Return New TPropertyItemFloat.Create(label, value, id, parent)
End Function


Type TPropertyItemFloat Extends TPropertyItem

	Method Create:TPropertyItemFloat(newLabel:String, defaultValue:Float, id:Int, newParent:TPropertyGroup)

		itemID = id
		CreateItemPanel(newParent)
		SetGadgetText(label, newLabel)

		interact = CreateTextField(interactX, 2, INTERACT_WIDTH, ITEM_SIZE - 2, mainPanel)
		SetGadgetLayout(interact, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_CENTERED)
		SetGadgetText(interact, FloatToString(defaultValue))
		SetGadgetFilter(interact, FilterInput)
		
		
		AddHook(EmitEventHook, eventHandler, Self, 0)
		newParent.AddItem(Self)
		Return Self
	End Method
	
	
	
	Function eventHandler:Object(id:Int, data:Object, context:Object)
		Local tmpItem:TPropertyItemFloat = TPropertyItemFloat(context)
		If tmpItem Then data = tmpItem.eventHook(id, data, context)
		Return data
	End Function
	
	

	Method eventHook:Object(id:Int, data:Object, context:Object)
	
		Local tmpEvent:TEvent = TEvent(data)
		If Not tmpEvent Then Return data
		
		Select tmpEvent.source
			Case interact
				Select tmpEvent.id
					Case EVENT_GADGETLOSTFOCUS
						If GadgetText(interact) = "" Then SetGadgetText(interact, "0.0")
						CreateItemEvent(EVENT_PG_ITEMCHANGED, GadgetText(interact))
						
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
	
	
	
	rem
	bbdoc: Gets float value
	endrem	
	Method GetValue:Float()
		Return Float(GadgetText(interact))
	End Method
	
	
	
	rem
	bbdoc: Sets float value
	endrem	
	Method SetValue(value:Float)
		SetGadgetText(interact, FloatToString(value))
	End Method
	
	
	
	rem
	bbdoc: Filters user input
	endrem
	Function FilterInput:Int(event:TEvent, context:Object)
		If event.id = EVENT_KEYCHAR
			'allow backspace
			If event.data = 8 Then Return 1
			'allow period
			If event.data = 46 Then Return 1
			'allow only 0-9
			If event.data < 48 Or event.data > 57 Return 0
		EndIf
		Return 1
	End Function

		
	
	rem
	bbdoc: Exports float to csv string 
	endrem
	Method ExportToString:String()
		Return "parameter,float," + GadgetText(label) + "," + FloatToString(Float(GadgetText(interact)))
	End Method
	
	

	'Stolen from John Klint. Thanks.
	Method FloatToString:String(value:Float, places:Int = 3)
		Local sign:Int = Sgn(value)
		value = Abs(value)
		Local i:Int = Round(value * 10 ^ places)
		Local ipart:Int = Int(i / 10 ^ places)
		Local dpart:Int = i - ipart * 10 ^ places
		Local si:String = ipart
		Local di:String
		If dpart > 0
			di = dpart
			While di.length < places
				di = "0" + di
			Wend
			di = "." + di
		EndIf
		While Right(di,1)="0"
			di = Left(di, di.length - 1)
		Wend
		If di = "" di = ".0"
		If sign = -1 si = "-" + si
		
		Return si+di
	End Method
	
	
	
	Method Round:Int(val:Float)
		Local decimal:Float
		decimal = val - Floor(val)
		If decimal < 0.5 Return Floor(val) Else Return Ceil(val)
	EndMethod
	
	
	
'	Method Clone:TPropertyItem()
'		Local s:TPropertyItemFloat = New TPropertyItemFloat.Create(Self.GetName(), Self.GetValue(), Self.GetParent())
'		Return s
'	End Method	
	
End Type

