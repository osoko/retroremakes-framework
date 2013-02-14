Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TSubMenuItem Extends TMenuItem
	
	' label of menu to activate when users selects this submenuitem
	' set _nextMenuLabel to 'back' to force a menumanager.previousmenu()
	Field _nextMenuLabel:String
										
	

	Method Activate()
		If _nextMenuLabel = "back"
			TMenuManager.GetInstance().PreviousMenu()
		Else
			TMenuManager.GetInstance().GoToMenu(_nextMenuLabel)
		End If
	End Method

	
			
	Method SetNextMenu(label:String)
		_nextMenuLabel = label
	End Method
	
	
	
	Method Update()
	End Method
	
End Type