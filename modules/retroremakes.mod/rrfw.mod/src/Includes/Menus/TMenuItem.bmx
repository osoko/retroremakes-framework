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

'menu item base class


Type TMenuItem

	Field _label:String
	Field _footer:String
	
	Field _menuManager:TMenuManager		' reference
	Field _menu:TMenu					' reference
	
	Method New()
		_label = "item"
	End Method
		
	Method ToString:String()
		Return _label
	End Method
	
	Method GetFooter:String()
		Return _footer
	End Method
	
	Method SetText(label:String, footer:String = "")
		_label = label
		_footer = footer
	End Method
		
	Method Update() Abstract
	Method Activate() Abstract
	
End Type