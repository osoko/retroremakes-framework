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

rem
	bbdoc: Abstract Type definining a renderable object
	about: TRenderable derived objects can be added to render layers to be
	automatically rendered and updated but the layer manager
end rem
Type TRenderable Abstract
	
	' The layer this renderable is currently attached to
	Field _layer:Int
	
	' The z-depth of this renderable, used to manipulate draw order on a layer
	Field _zDepth:Int
	
	
	
	rem
		bbdoc: Get the layer this object is currently attached to
	endrem	
	Method GetLayer:Int()
		Return _layer
	End Method
	
	
	
	rem
		bbdoc: Get the z-depth of this object
	endrem
	Method GetZDepth:Int()
		Return _zDepth
	End Method
	
	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_layer = 0
		_zDepth = 0
	End Method
	
	
	
	rem
		bbdoc: Render this object
	endrem
	Method Render(tweening:Double, fixed:Int = False) Abstract

	
	
	rem
		bbdoc: Set the layer this object is attached to
		about: Do not call this manually, instead add the object to a layer
		using the layer manager
	endrem
	Method SetLayer(value:Int)
		_layer = value
	End Method
	
	
	
	rem
		bbdoc: Set the z-depth of this object
	endrem
	Method SetZDepth(value:Int)
		_zDepth = value
	End Method

	
	
	rem
		bbdoc: Function used to sort renderable objects by z-depth
	endrem
	Function SortByZDepth:Int(o1:Object, o2:Object)
		Return TRenderable(o1).GetZDepth() - TRenderable(o2).GetZDepth()
	End Function
	
	
	
	Method ToString:String()
		Return "Renderable:" + Super.ToString()
	End Method
	
	
	
	rem
		bbdoc: Update this object
	endrem
	Method Update() Abstract
	
End Type
