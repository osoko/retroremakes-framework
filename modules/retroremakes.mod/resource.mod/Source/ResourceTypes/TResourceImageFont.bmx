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

Type TResourceImageFont Extends TResource

	Field font:TImageFont

	Field size:Int
	Field flags:Int
	
	
	Method Free()
		font = Null
	End Method
	
	
	
	Method GetResource:TImageFont()
		Return font
	End Method
	
	
			
	Method Load(path:String, size:Int = 12, flags:Int = SMOOTHFONT)
		font = LoadImageFont(path, size, flags)
		Self.path = path
		Self.size = size
		Self.flags = flags
		filename = path
	End Method

End Type