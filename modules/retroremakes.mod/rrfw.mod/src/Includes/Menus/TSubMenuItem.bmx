

Type TSubMenuItem Extends TMenuItem
	
	Field _nextMenuLabel:String			' label of menu to activate when users selects this submenuitem
										' set _nextMenuLabel to 'back' to force a menumanager.previousmenu()
	Method SetNextMenu(label:String)
		_nextMenuLabel = label
	End Method
	
	Method Update()
	End Method
	
	Method Activate()
		If _nextMenuLabel = "back"
			_menuManager.PreviousMenu()
		Else
			_menuManager.GoToMenu(_nextMenuLabel)
		End If
	End Method

End Type