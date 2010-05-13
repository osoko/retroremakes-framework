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

Type TResourceAnimImage Extends TResource
	
	Field image:TImage
	
	Method Load(path:String, cell_width:Int, cell_height:Int, first_cell:Int, cell_count:Int, flags:Int = -1)
		image = LoadAnimImage(path, cell_width, cell_height, first_cell, cell_count, flags)
		filename = path
	End Method
	
	Method GetResource:TImage()
		IncRefCount()
		Return image
	End Method
	
	Method Free()
		image = Null
	End Method

End Type