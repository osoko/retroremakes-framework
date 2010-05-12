rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TResourceImage Extends TResource

	Field image:TImage
	Field flags:Int
	
	Method Load(path:String, flags:Int = -1)
		image = LoadImage(path, flags)
		filename = path
	End Method
	
	Method GetResource:TImage()
		Return image
	End Method

	Method Free()
		image = null
	End Method
		
End Type