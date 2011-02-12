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

rem
	bbdoc: An option which can be added to TOptionMenuItem
end rem
Type TMenuOption
	
	Field _label:String
	Field _obj:Object

	Method SetLabel(s:String)
		_label = s
	End Method	
	
	Method ToString:String()
		Return _label
	End Method
	
	Method SetOptionObject(o:Object)
		_obj = o
	End Method
	
	Method GetOptionObject:Object()
		Return _obj
	End Method

End Type

