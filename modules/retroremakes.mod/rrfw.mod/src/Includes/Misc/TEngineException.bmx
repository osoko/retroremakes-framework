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

rem
	bbdoc: Custom exception type
endrem
Type TEngineException Extends TBlitzException
	Field error:String
	
	Method ToString$()
		Return error
	End Method
	
	Function Create:TEngineException(error:String)
		Local t:TEngineException = New TEngineException
		t.error=error
		Return t
	End Function
End Type