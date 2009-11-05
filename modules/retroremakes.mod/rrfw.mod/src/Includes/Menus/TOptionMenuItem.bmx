

Type TOptionMenuItem Extends TMenuItem

	Field _optionsList:TList
	Field _currentOption:TMenuOption		' ?
	
	Method New()
		_optionsList = New TList
	End Method
	
	Method Update()
	End Method
	
	Method Activate()
		
	End Method

'	Method AddItemOption:TMenuItemOption(newLabel:String, newFooter:String, spacer:Int = False)
'		Local m:TmenuItemOption = New TmenuItemOption
'		m.SetLabel(newLabel)
'		m.SetFooter(newFooter)
'		m.SetSpacer(spacer)
'		_itemsList.AddLast(m)
'		Return m
'	End Method

	Method PreviousOption()
		If _currentOption = _optionsList.First() Then Return
		Local thisLink:TLink = _optionsList.FindLink(_currentOption)
		Local previousLink:TLink = thisLink.PrevLink()
		_currentOption = TMenuOption(previousLink.Value())
	End Method

	Method NextOption()
		If _currentOption = _optionsList.Last() Then Return
		Local thisLink:TLink = _optionsList.FindLink(_currentOption)
		Local nextLink:TLink = thisLink.NextLink()
		_currentOption = TMenuOption(nextLink.Value())
	End Method
	
	Method GetCurrentOption:TMenuOption()
		Return _currentOption
	End Method
	
	Method SetCurrentOptionByName(name:String)
		For Local o:TMenuOption = EachIn _optionsList
			If o.ToString() = name
				_currentOption = o
				Return
			EndIf
		Next
		Throw "Could not set option with name: " + name
	End Method
	
	Method SetCurrentOptionByObject(obj:Object)
		For Local o:TMenuOption = EachIn _optionsList
			If o.ToString() = obj
				_currentOption = o
				Return
			EndIf
		Next
		Throw "Could not set option by object"
	End Method

	
	Method ToString:String()
		Local prefix:String, suffix:String
		If _optionsList.IsEmpty() Then Return _label + " : None"

		If _currentOption <> _optionsList.First() Then prefix = "< "
		If _currentOption <> _optionsList.Last() Then suffix = " >"
		Return prefix + _label + " : " + _currentOption.ToString() + suffix
	End Method

End Type