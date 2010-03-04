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
	Global _instance:TLayerManager
	
	' List of all active layers
	Field _layers:TList
	
	' Whether the layers are locked for their Update() and Render() calls
	Field _locked:Int
	
	
	
	rem
		bbdoc: Add a renderable object to the layer referred to by the specified id
		returns: True if successfull, otherwise false		
	endrem
	Method AddRenderableToLayerById:Int(renderable:TRenderable, id:Int)
		Local layer:TRenderLayer = GetLayerById(id)
		If layer
			Return layer.AddRenderable(renderable, _locked)
		Else
			' Layer doesn't already exist, so we'll try and create it
			If CreateLayer(id, "[AutoRenderLayer" + id + "]")
				Return AddRenderableToLayerById(renderable, id)
			Else
				Return False
			End If
		EndIf
	End Method
	
	
	
	rem
		bbdoc: Add a Renderable object to the layer referred to by the specified name
		returns: True if successfull, otherwise false		
	endrem	
	Method AddRenderableToLayerByName:Int(renderable:TRenderable, name:String)
		Local layer:TRenderLayer = GetLayerByName(name)
		If layer
			Return layer.AddRenderable(renderable, _locked)
		Else
			' Layer doesn't already exist, so we'll try and create it
			Local id:Int = GetNextId()
			If CreateLayer(id, name)
				Return AddRenderableToLayerById(renderable, id)
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
		If Not LayerNameExists(name) And Not LayerIdExists(id)
			Local layer:TRenderLayer = New TRenderLayer
			layer.SetId(id)
			layer.SetName(name)
			_layers.AddLast(layer)
			_layers.Sort()
			Return True
		Else
			rrLogWarning("[" + tostring() + "] Unable to create layer with id: " + id + ", name: " + name + ..
				". A layer already exists with one or more of those values")
			Return False
		EndIf
	End Method
	
	
		
	rem
		bbdoc: Destroys the specified layer
		about: This clears all render objects from the layer, and then removes the layer
		returns: True on success, otherwise False		
	endrem
	Method DestroyLayer:Int(layer:TRenderLayer)
		If Not layer Then Return False
		
		layer.Flush()
		_layers.Remove(layer)
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
		bbdoc: Flush the layer referred to by the specified name
		returns: True if it has been flushed, otherwise False
	endrem
	Method FlushLayerByName:Int(name:Int)
		Return FlushLayer(GetLayerByName(name))
	End Method
		
	
		
	rem
		bbdoc: Flush the specified layer
		about: This clears all render objects from the layer
		returns: True on success, otherwise False		
	endrem
	Method FlushLayer:Int(layer:TRenderLayer)
		If Not layer Then Return False
		
		layer.Flush()
		Return True
	End Method
	
	
	
	rem
		bbdoc: Flush the layer referred to by the specified id
		returns: True if it has been flushed, otherwise False
	endrem
	Method FlushLayerById:Int(id:Int)
		Return FlushLayer(GetLayerById(id))
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
	Method LayerIdExists:Int(id:Int)
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
	Method LayerNameExists:Int(name:String)
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
		If Not _instance
			Return New TLayerManager
		Else
			Return _instance
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Get the TRenderLayer associated with the specified id
		returns: TRenderLayer or Null if it doesn't exist
	endrem
	Method GetLayerById:TRenderLayer(id:Int)
		For Local layer:TRenderLayer = EachIn _layers
			If layer.GetId() = id
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
		For Local layer:TRenderLayer = EachIn _layers
			If layer.GetName() = name
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
			If LayerIdExists(id)
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
		_layers = New TList
		_locked = False
		Super.Initialise()
	End Method
	
	
	
	rem
		bbdoc: Constructor
		about: You should not call this manually, instead you should use GetInstance()
	endrem
	Method New()
		If _instance rrThrow "Cannot create multiple instances of Singleton Type"
		_instance = Self
		Initialise()
	EndMethod
	
	
	
	rem
		bbdoc: Processes any object add/removes that were deferred during the update/render process
	endrem
	Method ProcessDeferredObjects()
		If _locked Then Return
		
		For Local layer:TRenderLayer = EachIn _layers
			layer.ProcessDeferred(_locked)
		Next
	End Method
	
		
	
	rem
		bbdoc: Render all layers
	endrem
	Method Render()
		Local tweening:Double = TFixedTimestep.GetInstance().GetTweening()
		Local fixed:Int = TGraphicsService.GetInstance().UseFixedPointRendering()
		_locked = True
		For Local layer:TRenderLayer = EachIn _layers
			layer.Render(tweening, fixed)
		Next
		_locked = False
	End Method

	
	
	rem
		bbdoc: Remove a renderable object from the layer it belongs to
	endrem
	Method RemoveRenderable(renderable:TRenderable)
		Local layer:TRenderLayer = GetLayerById(renderable.GetLayer())
		layer.RemoveRenderable(renderable, _locked)
	End Method
	
	
	
	Method ToString:String()
		Return name + ":" + Super.ToString()
	End Method
	
	
	
	rem
		bbdoc: Update all layers
	endrem
	Method Update()
		If TGameEngine.GetInstance().enginePaused Then Return
		
		_locked = True
		For Local layer:TRenderLayer = EachIn _layers
			layer.Update()
		Next
		_locked = False
		ProcessDeferredObjects()
	End Method
	
EndType
