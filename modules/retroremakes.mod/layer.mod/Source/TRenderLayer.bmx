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

	' A list of render object adds that have been deferred
	Field _deferredAdds:TList
	
	' A list of render object removes that have been deferred
	Field _deferredRemoves:TList
	
	' The layers unique id
	Field _id:Int
	
	' The layers unique name
	Field _name:String
	
	' The list of objects to render for this layer
	Field _renderables:TList


	
	rem
		bbdoc: Add an actor to this layer
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false
	endrem
	Method AddRenderable:Int(renderable:TRenderable, locked:Int)
		If locked
			_deferredAdds.AddLast(renderable)
		Else
			If _renderables.AddLast(renderable)
				renderable.SetLayer(_id)
				_renderables.Sort(True, TRenderable.SortByZDepth)
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
		Return _id - TRenderLayer(withObject)._id
	End Method
	
	
	
	rem
		bbdoc: Flush the layer
		about: This clear the layer's render object list
	endrem
	Method Flush()
		For Local renderable:TRenderable = EachIn _renderables
			renderable.SetLayer(Null)
		Next
		_renderables.Clear()
	End Method
	
	
	
	rem
		bbdoc: Get this layer's id
	endrem
	Method GetId:Int()
		Return _id
	End Method
	
	
	
	rem
		bbdoc: Get this layer's name
	endrem
	Method GetName:String()
		Return _name
	End Method
	
	
	
	rem
		bbdoc: Write log information about renderables
		about: Logs the ToString() value of every renderable assigned to the layer
	endrem
	Method LogCurrentRenderables()
		If _renderables.Count() > 0
			For Local renderable:TRenderable = EachIn _renderables
				LogInfo("[Layer: " + ToString() + "] has renderable: " + renderable.ToString())
			Next
		Else
			LogInfo("[Layer: " + ToString() + "] has no renderables")
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_renderables = New TList
		_deferredAdds = New TList
		_deferredRemoves = New TList
	End Method
	
	
	
	rem
		bbdoc: Process any add/removes that were deferred during the update process
	endrem
	Method ProcessDeferred(locked:Int)
		For Local renderable:TRenderable = EachIn _deferredAdds
			AddRenderable(renderable, locked)
			_deferredAdds.Remove(renderable)
		Next
		
		For Local renderable:TRenderable = EachIn _deferredRemoves
			RemoveRenderable(renderable, locked)
			_deferredRemoves.Remove(renderable)
		Next		
	End Method
	
	
	
	rem
		bbdoc: Removes an actor from the layer
		returns: True if the actor has been removed, otherwise False
	endrem
	Method RemoveRenderable:Int(renderable:TRenderable, locked:Int)
		If locked
			_deferredRemoves.AddLast(renderable)
			Return False
		Else
			_renderables.Remove(renderable)
			renderable.SetLayer(Null)
		End If
	End Method
	
	
	
	rem
		bbdoc: Calls the Render method of all actors on this layer
		about: tweening is the render tweening value calculated by TFixedTimestep.
		If fixed is True, rendering position will be rounded to an integer pixel value,
		otherwise sub-pixel rendering is used.
	endrem
	Method Render(tweening:Double, fixed:Int)
		For Local renderable:TRenderable = EachIn _renderables
			If TGameEngine.GetInstance().GetPaused()
				' This avoids twitching objects when the engine is paused
				tweening = 0.0
			EndIf
			renderable.Render(tweening, fixed)
		Next
	End Method

	
	
	rem
		bbdoc: Set the id of this layer
	endrem
	Method SetId(id:Int)
		_id = id
	End Method
	
	
	
	rem
		bbdoc: Set the id of this layer
	endrem
	Method SetName(name:String)
		_name = name
	End Method
	
	
		
	Method ToString:String()
		Return _name + ":" + Super.ToString()
	End Method
	
	
	
	rem
		bbdoc: Calls the Update() method of all actors in this layer
	endrem
	Method Update()
		For Local renderable:TRenderable = EachIn _renderables
			renderable.Update()
		Next
	End Method
	
End Type
