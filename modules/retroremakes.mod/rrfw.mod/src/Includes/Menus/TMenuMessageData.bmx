

Const MENU_ACTION_START:Int = 1
Const MENU_ACTION_UNPAUSE:Int = 2
Const MENU_ACTION_QUIT:Int = 3
Const MENU_ACTION_CANCEL:Int = 4

Const MSG_MENU:Int = 893			'whatever =]

Type TMenuMessageData Extends TMessageData

	Field action:Int					' game manager reads this field to see which action to perform
	
End Type