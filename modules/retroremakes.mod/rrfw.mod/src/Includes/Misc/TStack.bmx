rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TStack Extends TList
	
	Method Push(entry:Object)
		AddLast(entry)
	End Method
	
	Method Pop:Object()
		Return RemoveLast()
	End Method
	
	Method Peek:Object()
		Return Last()
	End Method
	
End Type
