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

Rem
	bbdoc: Base class for input devices that can be used by the engine.
End Rem
Type TInputDevice Abstract

	Field name:String = "Unidentified Input Device"

	Method ToString:String()
		Return name
	End Method
	
	
	
	Method Update()
	End Method
	
End Type
