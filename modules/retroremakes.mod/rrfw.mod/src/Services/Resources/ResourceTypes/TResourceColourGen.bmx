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

Type TResourceColourGen Extends TResource

	Field colours:TColourGen
	
	Method Load(path:String)
		colours = TColourGen.Load(path)
		filename = path
	End Method
	
	Method GetResource:TColourGen()
		Return colours
	End Method
	
	Method Free()
		colours = Null
	End Method
	
End Type