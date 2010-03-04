Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Const MENU_ACTION_START:Int = 1
Const MENU_ACTION_UNPAUSE:Int = 2
Const MENU_ACTION_QUIT:Int = 3
Const MENU_ACTION_CANCEL:Int = 4
Const MENU_ACTION_GRAPHICS_APPLY:Int = 5
'Const MENU_ACTION_SOUND_APPLY:Int = 6
'Const MENU_ACTION_INPUT_APPLY:Int = 7

Type TMenuMessageData Extends TMessageData

	Field action:Int					' game manager reads this field to see which action to perform
	
End Type
