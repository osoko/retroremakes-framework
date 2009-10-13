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
	bbdoc: Service for managing render layers
endrem
Type TLayerManager Extends TGameService
	
	rem
		bbdoc: The singleton instance of the class
	endrem
	Global instance:TLayerManager
	
	Field LAllLayers:TList
	Field locked:Int
	
	rem
		bbdoc: Add an actor to the layer referred to by the specified id
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false		
	endrem
	Method AddRenderObjectToLayerById:Int(renderObject:TRenderable, id:Int)
		Local layer:TRenderLayer = GetLayerById(id)
		If layer
			Return layer.AddRenderObject(renderObject, locked)
		Else
			' Layer doesn't already exist, so we'll try and create it
			If CreateLayer(id, "[AutoRenderLayer" + id + "]")
				Return AddRenderObjectToLayerById(renderObject, id)
			Else
				Return False
			End If
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Add an actor to the layer referred to by the specified name
		about: Actors are sorted by zDepth when added to a layer
		returns: True if successfull, otherwise false		
	endrem	
	Method AddRenderObjectToLayerByName:Int(renderObject:TRenderable, name:String)
		Local layer:TRenderLayer = GetLayerByName(name)
		If layer
			Return layer.AddRenderObject(renderObject, locked)
		Else
			' Layer doesn't already exist, so we'll try and create it
			Local id:Int = GetNextId()
			If CreateLayer(id, name)
				Return AddRenderObjectToLayerById(renderObject, id)
			Else
				Return False
			End If
		EndIf
	End Method
	
		
	rem
		bbdoc: Creates a new render layer with the provided id and name
		returns:
		about: The new layer will only be created if the provided id and name are not
		already in use.
	endrem	
	Method CreateLayer:Int(id:Int, name:String)
		If Not DoesLayerNameExist(name) And Not DoesLayerIdExist(id)
			Local layer:TRenderLayer = New TRenderLayer
			layer.id = id
			layer.name = name
			LAllLayers.AddLast(layer)
			LAllLayers.Sort()
			Return True
		Else
			rrLogWarning("[" + tostring() + "] Unable to create layer with id: " + id + ", name: " + name + ..
				". A layer already exists with one or more of those values")
			Return False
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Destroys the specified layer
	endrem
	Method DestroyLayer:Int(layer:TRenderLayer)
		If Not layer Then Return False
		
		layer.Destroy()
		LAllLayers.Remove(layer)
		Return True
	End Method
	
	
	
	rem
		bbdoc: Destroy the layer referred to by the specified id
		returns: True if it has been destroyed, otherwise False
	endrem
	Method DestroyLayerById:Int(id:Int)
		Return DestroyLayer(GetLayerById(id))
	End Method
	
	
	
	rem
		bbdoc: Destroy the layer referred to by the specified name
		returns: True if it has been destroyed, otherwise False
	endrem
	Method DestroyLayerByName:Int(name:Int)
		Return DestroyLayer(GetLayerByName(name))
	End Method
		
	
		
	rem
		bbdoc: Check whether the specified render layer id already exists or not
		returns: True if it does exist, otherwise False
	endrem
	Method DoesLayerIdExist:Int(id:Int)
		If GetLayerById(id)
			Return True
		Else
			Return False
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Check whether the specified render layer name already exists or not
		returns: True if it does exist, otherwise False
	endrem	
	Method DoesLayerNameExist:Int(name:String)
		If GetLayerByName(name)
			Return True
		Else
			Return False
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Returns the instance of this Singleton, or creates a new
		instance if one doesn't exist
	endrem		
	Function GetInstance:TLayerManager()
		If Not instance
			instance = New TLayerManager
			Return instance
		Else
			Return instance
		EndIf
	End Function
	
	rem
		bbdoc: Get the TRenderLayer associated with the specified id
		returns: TRenderLayer or Null if it doesn't exist
	endrem
	Method GetLayerById:TRenderLayer(id:Int)
		For Local layer:TRenderLayer = EachIn LAllLayers
			If layer.id = id
				Return layer
			End If
		Next		
		Return Null
	End Method

	
	
	rem
		bbdoc: Get the TRenderLayer associated with the specified name
		returns: TRenderLayer or Null if it doesn't exist
	endrem	
	Method GetLayerByName:TRenderLayer(name:String)
		For Local layer:TRenderLayer = EachIn LAllLayers
			If layer.name = name
				Return layer
			End If
		Next
		Return Null
	End Method
		
	rem
		bbdoc: Get the next available layer id, starting from 0
		returns: int
	endrem
	Method GetNextId:Int()
		Local id:Int = 0
		Repeat
			If DoesLayerIdExist(id)
				id:+1
			Else
				Exit
			End If
		Forever
		Return id
	End Method
		
	rem
		bbdoc: Initialise this game service and add it to the game engine
	endrem
	Method Initialise()
		SetName("Render Layer Manager")
		LAllLayers = New TList
		locked = False
		Super.Initialise()
	End Method
	
	rem
		bbdoc: Constructor
		about: You should not call this manually, instead you should use GetInstance()
	endrem
	Method New()
		If instance Throw "Cannot create multiple instances of Singleton Type"
		Initialise()
	EndMethod
	
	
	
	rem
		bbdoc: Processes any object add/removes that were deferred during the update/render process
	endrem
	Method ProcessDeferredObjects()
		If locked Then Return
		
		For Local layer:TRenderLayer = EachIn LAllLayers
			layer.ProcessDeferred(locked)
		Next
	End Method
	
		
	Method Render()
		Local tweening:Double = TFixedTimestep.GetInstance().GetTweening()
		Local fixed:Int = TGraphicsService.GetInstance().fixedPointRendering
		locked = True
		For Local layer:TRenderLayer = EachIn LAllLayers
			layer.Render(tweening, fixed)
		Next
		locked = False
	End Method

	
	Method RemoveRenderObject(renderObject:TRenderable)
		Local layer:TRenderLayer = GetLayerById(renderObject.GetLayer())
		layer.RemoveRenderObject(renderObject, locked)
	End Method
	
	
	Method ToString:String()
		Return name
	End Method
	
	
	Method Update()
		If TGameEngine.GetInstance().enginePaused Then Return
		
		locked = True
		For Local layer:TRenderLayer = EachIn LAllLayers
			layer.Update()
		Next
		locked = False
		ProcessDeferredObjects()
	End Method
	
EndType
