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
	bbdoc: Class representing and managing polygons 
End Rem
Type TPolygon
	Field vertices:TVector2D[]
	Field tformedVertices:TVector2D[]	'transformed vertices
	Field position:TVector2D = New TVector2D
	Field scale:TVector2D = New TVector2D
	Field handle:TVector2D = New TVector2D
	Field origin:TVector2D = New TVector2D
	Field rotation:Float = 0.0
	
	Function Create:TPolygon(vertices:TVector2D[])
		If vertices.Length < 3 Then Throw "Cannot create TPolygon with less than three vertices"
		
		Local polygon:TPolygon = New TPolygon
		polygon.vertices = New TVector2D[vertices.Length]
		polygon.tformedVertices = New TVector2D[vertices.Length]
		For Local i:Int = 0 To vertices.Length - 1
			polygon.vertices[i] = vertices[i]
		Next
		Return polygon
	EndFunction
	
	Method SetPosition(position:TVector2D)
		Self.position.x = position.x
		Self.position.y = position.y
	End Method
	
	Method SetScale(scale:TVector2D)
		Self.scale.x = scale.x
		Self.scale.y = scale.y
	End Method
	
	Method SetHandle(handle:TVector2D)
		Self.handle.x = handle.x
		Self.handle.y = handle.y
	End Method
	
	Method SetOrigin(origin:TVector2D)
		Self.origin.x = origin.x
		Self.origin.y = origin.y
	End Method
	
	Method SetRotation(rotation:Float)
		Self.rotation = rotation
	End Method
	
	Method GetPosition:TVector2D()
		Return position.Copy()
	End Method
	
	Method GetScale:TVector2D()
		Return scale.Copy()
	End Method
	
	Method GetHandle:TVector2D()
		Return handle.Copy()
	End Method
	
	Method GetOrigin:TVector2D()
		Return origin.Copy()
	End Method
	
	Method GetRotation:Float()
		Return rotation
	End Method	
	
	Method Transform()
		
	End Method
End Type
