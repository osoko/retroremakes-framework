Type TResourceManager Extends TGameService

	Global instance:TResourceManager		' This holds the singleton instance of this Type
	
	Field resources:TMap
	
	Field autoFreeResources:Int = True
		
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	
		
	Function GetInstance:TResourceManager()
		If Not instance
			Return New TResourceManager
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 



	Method Initialise()
		' Load ini file stuff here
		SetName("Resource Manager")
		Self.resources = CreateMap()
		
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	
	
	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method

	
	
	Method LoadColourGen(path:String)
		Local newResource:TResourceColourGen = New TResourceColourGen
		newResource.Load(path)
		newResource.IncRefCount()
		resources.Insert(path, newResource)
		rrLogInfo(ToString() + ": Loaded resource ~q" + path + "~q")
	End Method
		
	
	
	Method LoadImage(path:String, flags:Int = -1)
		Local newResource:TResourceImage = New TResourceImage
		newResource.Load(path, flags)
		newResource.IncRefCount()
		resources.Insert(path, newResource)
		rrLogInfo(ToString() + ": Loaded resource ~q" + path + "~q")
	End Method
	
	
	
	Method LoadAnimImage(path:String, cell_width:Int, cell_height:Int, first_cell:Int, cell_count:Int, flags:Int = -1)
		Local newResource:TResourceAnimImage = New TResourceAnimImage
		newResource.Load(path, cell_width, cell_height, first_cell, cell_count, flags)
		newResource.IncRefCount()
		resources.Insert(path, newResource)
		rrLogInfo(ToString() + ": Loaded resource ~q" + path + "~q")
	End Method	
	
	
	
	Method LoadImageFont(path:String, size:Int = 12, style:Int = SMOOTHFONT)
		Local newResource:TResourceImageFont = New TResourceImageFont
		newResource.Load(path, size, style)
		newResource.IncRefCount()
		resources.Insert(path + String(size), newResource)
		rrLogInfo(ToString() + ": Loaded resource ~q" + path + String(size) + "~q")
	End Method

	
	
	Method DeleteResource(path:String)
		resources.Remove(path)
	End Method
	
	
	
	Method FreeResource(path:String)
		Local resource:TResource = GetResource(path)
		If resource.DecRefCount() = 0
			If autoFreeResources
				resource.Free()
				DeleteResource(path)
				rrLogInfo(ToString() + ": Freeing resource ~q" + path + "~q")
			End If
		End If
	End Method
	
	
	
	Method FreeResourceColourGen:TColourGen(path:String)
		FreeResource(path)
		Return Null
	End Method
			
	
	
	Method FreeResourceImage:TImage(path:String)
		FreeResource(path)
		Return Null
	End Method
	
	
	
	Method FreeResourceAnimImage:TImage(path:String)
		FreeResource(path)
		Return Null
	End Method
	
	
	
	Method FreeResourceImageFont:TImageFont(path:String, size:Int)
		FreeResource(path + String(size))
		Return Null
	End Method	
		
	
	
	Method GetResource:TResource(path:String)
		If resources.Contains(path)
			Return TResource(resources.ValueForKey(path))
		Else
			Throw "Resource does not exist: " + path
		EndIf
	End Method
	
	
	
	Method GetResourceColourGen:TColourGen(path:String)
		rrLogInfo(ToString() + ": Retrieving resource ~q" + path + "~q")
		Return TResourceColourGen(GetResource(path)).GetResource()
	End Method
		
	
	
	Method GetResourceImage:TImage(path:String)
		rrLogInfo(ToString() + ": Retrieving resource ~q" + path + "~q")
		Return TResourceImage(GetResource(path)).GetResource()
	End Method
	
	
	
	Method GetResourceAnimImage:TImage(path:String)
		rrLogInfo(ToString() + ": Retrieving resource ~q" + path + "~q")
		Return TResourceAnimImage(GetResource(path)).GetResource()
	End Method
	
	
	
	Method GetResourceImageFont:TImageFont(path:String, size:Int)
		rrLogInfo(ToString() + ": Retrieving resource ~q" + path + String(size) + "~q")
		Return TResourceImageFont(GetResource(path + String(size))).GetResource()
	End Method
	
	
	
	Method SetAutoFree(free:Int = True)
		autoFreeResources = free
	End Method
	
	
	
	Method GetAutoFree:Int()
		Return autoFreeResources
	End Method
	
	
	
	Method Reload()
		For Local resource:TResource = EachIn resources.Values()
			resource.Reload()
		Next
	End Method

EndType

Function rrFreeResourceAnimImage:TImage(path:String)
	Return TResourceManager.GetInstance().FreeResourceAnimImage(path)
End Function

Function rrFreeResourceColourGen:TColourGen(path:String)
	Return TResourceManager.GetInstance().FreeResourceColourGen(path)
End Function

Function rrFreeResourceImage:TImage(path:String)
	Return TResourceManager.GetInstance().FreeResourceImage(path)
End Function

Function rrFreeResourceImageFont:TImageFont(path:String, size:Int)
	Return TResourceManager.GetInstance().FreeResourceImageFont(path, size)
End Function

Function rrGetResourceAnimImage:TImage(path:String)
	Return TResourceManager.GetInstance().GetResourceAnimImage(path)
End Function

Function rrGetResourceColourGen:TColourGen(path:String)
	Return TResourceManager.GetInstance().GetResourceColourGen(path)
End Function

Function rrGetResourceImage:TImage(path:String)
	Return TResourceManager.GetInstance().GetResourceImage(path)
End Function

Function rrGetResourceImageFont:TImageFont(path:String, size:Int)
	Return TResourceManager.GetInstance().GetResourceImageFont(path, size)
End Function

Function rrLoadResourceAnimImage(path:String, cell_width:Int, cell_height:Int, first_cell:Int, cell_count:Int, flags:Int = -1)
	TResourceManager.GetInstance().LoadAnimImage(path, cell_width, cell_height, first_cell, cell_count, flags)
End Function

Function rrLoadResourceColourGen(path:String)
	TResourceManager.GetInstance().LoadColourGen(path)
End Function

Function rrLoadResourceImage(path:String, flags:Int = -1)
	TResourceManager.GetInstance().LoadImage(path, flags)
End Function

Function rrLoadResourceImageFont(path:String, size:Int = 12, style:Int = SMOOTHFONT)
	TResourceManager.GetInstance().LoadImageFont(path, size, style)
End Function

Function rrSetAutoFreeResources(free:Int = True)
	TResourceManager.GetInstance().SetAutoFree(free)
End Function

Function rrGetAutoFreeResources:Int()
	Return TResourceManager.GetInstance().GetAutoFree()
End Function