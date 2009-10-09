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
	Global LAllLayers:TList = New TList
	
	Field id:Int
	Field name:String
	Field renderObjects:TList
	
	rem
		bbdoc: Add an actor to this layer
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false
	endrem
	Method AddRenderObject:Int(renderObject:TRenderable)
		If renderObjects.AddLast(renderObject)
			renderObjects.Sort()
			Return True
		Else
			Return False
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Add an actor to the layer referred to by the specified id
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false		
	endrem
	Function AddRenderObjectToLayerById:Int(id:Int, renderObject:TRenderable)
		Local layer:TRenderLayer = TRenderLayer.GetLayerById(id)
		If layer
			Return layer.AddRenderObject(renderObject)
		Else
			' Layer doesn't already exist, so we'll try and create it
			If TRenderLayer.CreateLayer(id, "[AutoRenderLayer" + id + "]")
				Return TRenderLayer.AddRenderObjectToLayerById(id, renderObject)
			Else
				Return False
			End If
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Add an actor to the layer referred to by the specified name
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false		
	endrem	
	Function AddActorToLayerByName:Int(name:String, renderObject:TRenderable)
		Local layer:TRenderLayer = TRenderLayer.GetLayerByName(name)
		If layer
			Return layer.AddRenderObject(renderObject)
		Else
			' Layer doesn't already exist, so we'll try and create it
			Local id:Int = TRenderLayer.GetNextId()
			If TRenderLayer.CreateLayer(id, name)
				Return TRenderLayer.AddRenderObjectToLayerById(id, renderObject)
			Else
				Return False
			End If
		EndIf
	End Function	
	
	
	
	rem
		bbdoc: Compare with another TRenderLayer
		about: Comparison is performed on layer id
	endrem
	Method Compare:Int(withObject:Object)
		Return id - TRenderLayer(withObject).id
	End Method
	
	
	
	rem
		bbdoc: Creates a new render layer with the provided id and name
		returns:
		about: The new layer will only be created if the provided id and name are not
		already in use.
	endrem	
	Function CreateLayer:Int(id:Int, name:String)
		If Not TRenderLayer.DoesLayerNameExist(name) And Not TRenderLayer.DoesLayerIdExist(id)
			Local layer:TRenderLayer = New TRenderLayer
			layer.id = id
			layer.name = name
			TRenderLayer.LAllLayers.AddLast(layer)
			TRenderLayer.LAllLayers.Sort()
			Return True
		Else
			rrLogWarning("[TRenderLayer] Unable to create layer with id: " + id + ", name: " + name + ..
				". A layer already exists with one or more of those values")
			Return False
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Destroy the layer
		about: This clear the layer's actor list and removes itself from the list of layers
		returns: True on success, otherwise False
	endrem
	Method Destroy:Int()
		renderObjects.Clear()
		TRenderLayer.LAllLayers.Remove(Self)
		Return True
	End Method
	
	
	
	rem
		bbdoc: Destroy the layer referred to by the specified id
		returns: True if it has been destroyed, otherwise False
	endrem
	Function DestroyLayerById:Int(id:Int)
		Local layer:TRenderLayer = TRenderLayer.GetLayerById(id)
		If layer
			Return layer.Destroy()
		Else
			Return False
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Destroy the layer referred to by the specified name
		returns: True if it has been destroyed, otherwise False
	endrem
	Function DestroyLayerByName:Int(name:Int)
		Local layer:TRenderLayer = TRenderLayer.GetLayerByName(name)
		If layer
			Return layer.Destroy()
		Else
			Return False
		EndIf
	End Function	
		
	
	
	rem
		bbdoc: Check whether the specified render layer id already exists or not
		returns: True if it does exist, otherwise False
	endrem
	Function DoesLayerIdExist:Int(id:Int)
		Local layer:TRenderLayer = TRenderLayer.GetLayerById(id)
		If layer
			Return True
		Else
			Return False
		EndIf
	End Function
	
	
		
	rem
		bbdoc: Check whether the specified render layer name already exists or not
		returns: True if it does exist, otherwise False
	endrem	
	Function DoesLayerNameExist:Int(name:String)
		Local layer:TRenderLayer = TRenderLayer.GetLayerByName(name)
		If layer
			Return True
		Else
			Return False
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Get the TRenderLayer associated with the specified id
		returns: TRenderLayer or Null if it doesn't exist
	endrem
	Function GetLayerById:TRenderLayer(id:Int)
		For Local layer:TRenderLayer = EachIn TRenderLayer.LAllLayers
			If layer.id = id
				Return layer
			End If
		Next		
		Return Null
	End Function

	
	
	rem
		bbdoc: Get the TRenderLayer associated with the specified name
		returns: TRenderLayer or Null if it doesn't exist
	endrem	
	Function GetLayerByName:TRenderLayer(name:String)
		For Local layer:TRenderLayer = EachIn TRenderLayer.LAllLayers
			If layer.name = name
				Return layer
			End If
		Next
		Return Null
	End Function

	
	
	rem
		bbdoc: Get the next available id, starting from 0
		returns: int
	endrem
	Function GetNextId:Int()
		Local id:Int = 0
		Repeat
			If TRenderLayer.DoesLayerIdExist(id)
				id:+1
			Else
				Exit
			End If
		Forever
		Return id
	End Function
	
	
	
	rem
		bbdoc: Constructor
	endrem
	Method New()
		renderObjects = New TList
	End Method	

	
	
	
	rem
		bbdoc: Removes an actor from the layer
		returns: True if the actor has been removed, otherwise False
	endrem
	Method RemoveRenderObject:Int(renderObject:TRenderable)
		Return renderObjects.Remove(renderObject)
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
	
	
	
	rem
		bbdoc: Render all layers
		about: Layers are rendered in numerical order by id
	endrem
	Function RenderAllLayers(tweening:Double, fixed:Int)
		For Local layer:TRenderLayer = EachIn TRenderLayer.LAllLayers
			layer.Render(tweening, fixed)
		Next
	End Function
	
	
	
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
	
	

	rem
		bbdoc: Calls the Update() method of all actors in every layer
	endrem
	Function UpdateAllLayers()
		For Local layer:TRenderLayer = EachIn TRenderLayer.LAllLayers
			layer.Update()
		Next
	End Function	
	
End Type
