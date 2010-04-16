Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

Type TOptionMenuItem Extends TMenuItem

	Field _optionsList:TList
	Field _currentOption:TMenuOption
	Field _useGameSetting:Int

	
	Method New()
		_optionsList = New TList
		_useGameSetting = False
	End Method
	
	'override settext method to add a lookup to see if a default value for this item exists.
	Method SetText(label:String, footer:String = "")
		_label = label
		_footer = footer
		
		Local g:TGameSettings = TGameSettings.GetInstance()
		If g.iniFile.ParameterExists("Game", _label) Then _useGameSetting = True
	End Method
	
	Method Update()
	End Method
	
	Method Activate()
	End Method
	
	Method AddOption(o:TMenuOption)
		_optionsList.AddLast(o)
		_currentOption = TMenuOption(_optionsList.First())
	End Method
	
	Method GetOptions:TList()
		Return _optionsList
	End Method	

	Method PreviousOption()
		If _currentOption = _optionsList.First() Then Return
		Local thisLink:TLink = _optionsList.FindLink(_currentOption)
		Local previousLink:TLink = thisLink.PrevLink()
		_currentOption = TMenuOption(previousLink.Value())
		
		'send new value to game settings
		If _useGameSetting Then SetDefaultOption(_currentOption)
	End Method

	Method NextOption()
		If _currentOption = _optionsList.Last() Then Return
		Local thisLink:TLink = _optionsList.FindLink(_currentOption)
		Local nextLink:TLink = thisLink.NextLink()
		_currentOption = TMenuOption(nextLink.Value())
		If _useGameSetting Then SetDefaultOption(_currentOption)
	End Method
	
	Method GetCurrentOption:TMenuOption()
		Return _currentOption
	End Method
	
	Method SetCurrentOption(o:TMenuOption)
		_currentOption = o
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
			If o.GetOptionObject() = obj
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

	'needed to get the item name, minus the options component
	Method GetLabel:String()
		Return _label
	End Method

	'flag this menu item to save its selection to the gamesettings config file	
	Method EnableGameSetting()
		_useGameSetting = True
	End Method

	'Set an TMenuOption as default for this TMenuItem. Forces a setting to be created in the game section of the ini file.
	'this is for custom game options for which the setting needs to be saved
	'also called when option was changed. if the item contains a default, it is sent to the gamesettings.
	Method SetDefaultOption(o:TMenuOption)
		TGameSettings.GetInstance().SetStringVariable(_label, o.ToString())
	End Method

	'sync option on this item to the setting in TGameSettings.
	'if option cannot be found, the current option is used
	'...called by the menu manager after a menu change to ensure that item represents the setting in the config file
	Method SyncToDefaultOption()
		If _currentOption = Null Then Throw "no option on this item!"
		If _useGameSetting
			Local optionToSelect:String = TGameSettings.GetInstance().GetStringVariable(_label, _currentOption.ToString())
			SetCurrentOptionByName(optionToSelect)
		EndIf
	End Method

End Type