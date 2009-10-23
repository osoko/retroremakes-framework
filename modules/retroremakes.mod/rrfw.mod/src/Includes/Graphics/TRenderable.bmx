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
	bbdoc: Type description
end rem
Type TRenderable Abstract
	
	Field layer:Int
	Field zDepth:Int
	
'	Method Compare:Int(withObject:Object)
		'Return zDepth - TRenderable(withObject).zDepth
	'End Method
		
	Method GetLayer:Int()
		Return layer
	End Method
	
	Method GetZDepth:Int()
		Return zDepth
	End Method
	
	Method New()
		zDepth = 0
	End Method
	
	Method Render(tweening:Double, fixed:Int = False) Abstract
	
	Method SetLayer(value:Int)
		layer = value
	End Method
	
	Method SetZDepth(value:Int)
		zDepth = value
	End Method

	Method ToString:String()
		Return "Renderable: " + Super.ToString()
	End Method
	
	Method Update() Abstract
	
End Type
