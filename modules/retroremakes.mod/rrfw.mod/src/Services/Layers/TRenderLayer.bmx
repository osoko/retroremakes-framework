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
	bbdoc: A renderable layer
	about: A render layer contains one or more renderable objects. These
	objects will have their Update() and Render() methods called as part
	of the main loop. Each layer has an id which is used to prioritize
	updates and rendering. A layer with id=1 will be updated/rendered
	before a layer with id=3 for example. This means that you can ensure
	HUD elements are drawn above the rest of they graphics, etc.
end rem
Type TRenderLayer Extends TRenderable

	Field id:Int
	Field name:String
	Field renderObjects:TList
	Field deferredAdds:TList
	Field deferredRemoves:TList
	
	rem
		bbdoc: Add an actor to this layer
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false
	endrem
	Method AddRenderObject:Int(renderObject:TRenderable, locked:Int)
		If locked
			deferredAdds.AddLast(renderObject)
		Else
			If renderObjects.AddLast(renderObject)
				renderObject.SetLayer(id)
				renderObjects.Sort()
				Return True
			Else
				Return False
			EndIf
		End If
	End Method
	
	
	rem
		bbdoc: Compare with another TRenderLayer
		about: Comparison is performed on layer id
	endrem
	Method Compare:Int(withObject:Object)
		Return id - TRenderLayer(withObject).id
	End Method
	
	
	rem
		bbdoc: Destroy the layer
		about: This clear the layer's actor list and removes itself from the list of layers
		returns: True on success, otherwise False
	endrem
	Method Destroy()
		renderObjects.Clear()
	End Method
	
	
	rem
		bbdoc: Constructor
	endrem
	Method New()
		renderObjects = New TList
		deferredAdds = New TList
		deferredRemoves = New TList
	End Method
	
	rem
		bbdoc: Process any add/removes that were deferred during the update process
	endrem
	Method ProcessDeferred(locked:Int)
		For Local renderObject:TRenderable = EachIn deferredAdds
			AddRenderObject(renderObject, locked)
			deferredAdds.Remove(renderObject)
		Next
		
		For Local renderObject:TRenderable = EachIn deferredRemoves
			RemoveRenderObject(renderObject, locked)
			deferredRemoves.Remove(renderObject)
		Next		
	End Method
	
	
	rem
		bbdoc: Removes an actor from the layer
		returns: True if the actor has been removed, otherwise False
	endrem
	Method RemoveRenderObject:Int(renderObject:TRenderable, locked:Int)
		If locked
			deferredRemoves.AddLast(renderObject)
			Return False
		Else
			Return renderObjects.Remove(renderObject)
		End If
	End Method
	
	
	
	
	rem
		bbdoc: Calls the Render method of all actors on this layer
		about: tweening is the render tweening value calculated by TFixedTimestep.
		If fixed is True, rendering position will be rounded to an integer pixel value,
		otherwise sub-pixel rendering is used.
	endrem
	Method Render(tweening:Double, fixed:Int)
		For Local renderObject:TRenderable = EachIn renderObjects
			renderObject.Render(tweening, fixed)
		Next
	End Method

	
	
	
	Method ToString:String()
		Return name
	End Method
	
	
	
	rem
		bbdoc: Calls the Update() method of all actors in this layer
	endrem
	Method Update()
		For Local renderObject:TRenderable = EachIn renderObjects
			renderObject.Update()
		Next
	End Method
	

	
End Type
