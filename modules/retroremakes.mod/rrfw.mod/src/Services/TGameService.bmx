rem
	bbdoc: #TGameService
	about: #TGameService is the parent type of all services provided by the framework
	and can be extended easily to provide additional functionality to the framework
endrem
Type TGameService Abstract

	rem
	bbdoc: Reference to the #TGameService #DebugRender method.
	about: To optimise the #TGameEngine main loop, these @TMethod pointers
	are populated using @Reflection when the #TGameService instance registers
	itself with the TGameEngine instance
	endrem		
	Field debugRenderMethod:TMethod
	
	rem
		bbdoc: The priority of this #TGameService instance's #DebugRender method.
		about: All game services are put into a TList for each of the main
		TGameService methods.
		These TLists are sorted by priority so you can ensure that the methods
		are run in a particular order.  This is not a requirement for most services.
	endrem	
	Field debugRenderPriority:Int = 0
'#Region debugRenderPriority Get/Set Methods
	rem
		bbdoc: Get the #DebugRender priority of the #TGameService instance.
		returns: the #DebugRender priority
	endrem		
	Method GetDebugRenderPriority:Int()
		Return Self.debugRenderPriority
	End Method
	rem
		bbdoc: Set the #DebugRender priority of the #TGameService instance.
	endrem		
	Method SetDebugRenderPriority(value:Int)
		Self.debugRenderPriority = value
	End Method		
'#End Region 
	
	rem
		bbdoc: Debug #TProfilerSample for the #DebugRender method.
	endrem	
	Field debugRenderProfiler:TProfilerSample

	rem
		bbdoc: Reference to the #TGameService #DebugUpdate method.
		about: To optimise the #TGameEngine main loop, these @TMethod pointers
		are populated using @Reflection when the #TGameService instance registers
		itself with the TGameEngine instance
	endrem		
	Field debugUpdateMethod:TMethod
				
	rem
		bbdoc: The priority of this #TGameService instance's #DebugUpdate method.
		about: All game services are put into a TList for each of the main
		TGameService methods.
		These TLists are sorted by priority so you can ensure that the methods
		are run in a particular order.  This is not a requirement for most services.
	endrem	
	Field debugUpdatePriority:Int = 0
'#Region debugUpdatePriority Get/Set Methods
	rem
		bbdoc: Get the #DebugUpdate priority of the #TGameService instance.
		returns: the #DebugUpdate priority.
	endrem		
	Method GetDebugUpdatePriority:Int()
		Return Self.debugUpdatePriority
	End Method
	rem
		bbdoc: Set the #DebugUpdate priority of the #TGameService instance
		returns:
	endrem	
	Method SetDebugUpdatePriority(value:Int)
		Self.debugUpdatePriority = value
	End Method	
'#End Region 
	
	rem
		bbdoc: Debug #TProfilerSample for the #DebugUpdate method
	endrem	
	Field debugUpdateProfiler:TProfilerSample
	
	rem
		bbdoc: A reference to the game engine instance
	endrem
	Field engineInstance:TGameEngine
		
	rem
		bbdoc: The human readable name of the #TGameService instance.
	endrem
	Field name:String = "Game Service with No Name"
'#Region name Get/Set Methods
	Rem
		bbdoc: Get the name value in this TGameService object.
	End Rem
	Method GetName:String()
		Return Self.name
	End Method
	Rem
		bbdoc: Set the name value for this TGameService object.
	End Rem
	Method SetName(value:String)
		Self.name = value
	End Method
'#End Region 
	
	rem
		bbdoc: Reference to the #TGameService #Render method.
		about: To optimise the #TGameEngine main loop, these @TMethod pointers
		are populated using @Reflection when the #TGameService instance registers
		itself with the TGameEngine instance.
	endrem		
	Field renderMethod:TMethod
		
	rem
		bbdoc: The priority of this #TGameService instance's #Render method.
		about: All game services are put into a TList for each of the main
		TGameService methods.
		These TLists are sorted by priority so you can ensure that the methods
		are run in a particular order.  This is not a requirement for most services.
	endrem	
	Field renderPriority:Int = 0
'#Region renderPriority Get/Set Methods
	rem
		bbdoc: Get the #Render priority of the #TGameService instance.
		returns: the #Render priority
	endrem			
	Method GetRenderPriority:Int()
		Return Self.renderPriority
	End Method
	rem
		bbdoc: Get the #Render priority of the #TGameService instance
		returns:
	endrem	
	Method SetRenderPriority(value:Int)
		Self.renderPriority = value
	End Method	
'#End Region 
	
	rem
		bbdoc: Debug #TProfilerSample for the #Render method.
	endrem	
	Field renderProfiler:TProfilerSample
	
	rem
		bbdoc: Reference to the #TGameService #Start method.
		about: To optimise the #TGameEngine main loop, these @TMethod pointers
		are populated using @Reflection when the #TGameService instance registers
		itself with the TGameEngine instance.
	endrem	
	Field startMethod:TMethod
				
	rem
		bbdoc: The priority of this #TGameService instance's #Start method.
		about: All game services are put into a TList for each of the main
		TGameService methods.
		These TLists are sorted by priority so you can ensure that the methods
		are run in a particular order.  This is not a requirement for most services.
	endrem
	Field startPriority:Int = 0
'#Region startPriority Get/Set Methods
	rem
		bbdoc: Get the Start priority of the #TGameService instance
		returns: the #Start priority
	endrem
	Method GetStartPriority:Int()
		Return Self.startPriority
	End Method
	rem
		bbdoc: Set the #Start priority of the #TGameService instance
		returns:
	endrem		
	Method SetStartPriority(value:Int)
		Self.startPriority = value
	End Method		
'#End Region 

	rem
		bbdoc: Reference to the #TGameService #Update method.
		about: To optimise the #TGameEngine main loop, these @TMethod pointers
		are populated using @Reflection when the #TGameService instance registers
		itself with the TGameEngine instance.
	endrem		
	Field updateMethod:TMethod
				
	rem
		bbdoc: The priority of this #TGameService instance's #Update method.
		about: All game services are put into a TList for each of the main
		TGameService methods.
		These TLists are sorted by priority so you can ensure that the methods
		are run in a particular order.  This is not a requirement for most services.
	endrem	
	Field updatePriority:Int = 0
'#Region updatePriority Get/Set Methods
	rem
		bbdoc: Get the Update priority of the #TGameService instance
		returns: the #Update priority
	endrem
	Method GetUpdatePriority:Int()
		Return Self.updatePriority
	End Method
	rem
		bbdoc: Set the #Update priority of the #TGameService instance
		returns:
	endrem			
	Method SetUpdatePriority(value:Int)
		Self.updatePriority = value
	End Method	
'#End Region 
	
	rem
		bbdoc: Debug#TProfilerSample for the #Update method.
	endrem	
	Field updateProfiler:TProfilerSample	

	
	rem
		bbdoc: Add the #TGameService instance to the #TGameEngine.
		returns:
		about: This is adds a #TGameService instance to the #TGameEngine instance and
		also write a LOG_INFO message to the #TGameEngine log file.  It also populates
		the #updateMethod, #renderMethod, #startMethod, #debugUpdateMethod and
		#debugRenderMethod Fields with a pointer to those Methods if they exist.
	endrem					
	Method AddService(service:TGameService)
		TGameEngine.GetInstance().AddService(service)

		Local serviceObject:Object = Object(service)
		Local id:TTypeId = TTypeId.ForObject(serviceObject)
		Self.updateMethod:TMethod = id.FindMethod("Update")
		Self.renderMethod:TMethod = id.FindMethod("Render")
		Self.startMethod:TMethod = id.FindMethod("Start")
		Self.debugUpdateMethod:TMethod = id.FindMethod("DebugUpdate")
		Self.debugRenderMethod:TMethod = id.FindMethod("DebugRender")
	EndMethod



	rem
		bbdoc: Initialise the #TGameService instance.
		returns:
		about: This uses the #AddService method to register itself with the
		#TGameEngine instance and also writes a LOG_INFO message to the #TGameEngine
		log file.
	endrem
	Method Initialise()
		AddService(Self)
		TLogger.GetInstance().LogInfo("[" + ToString() + "] Initialised")
	End Method

	

	rem
		bbdoc: Remove the #TGameService instance from the #TGameEngine.
		returns:
		about: This is called by the #Shutdown Method and removes the #TGameService
		instance from the TGameEngine instance.
	endrem			
	Method RemoveService(service:TGameService)
		TGameEngine.GetInstance().RemoveService(service)
	EndMethod



	rem
		bbdoc: Compare Function used to sort the #TGameService instances by #DebugRender priorty
		returns:
		about: Used by the TGameEngine instance when adding services the relevant Method TLists
	endrem
	Function DebugRenderPrioritySort:Int(o1:Object, o2:Object)
		Local o1Priority:Int = TGameService(o1).GetDebugRenderPriority()
		Local o2Priority:Int = TGameService(o2).GetDebugRenderPriority()
		Return PrioritySort(o1Priority, o2Priority)
	End Function
	
	
	
	rem
		bbdoc: Compare Function used to sort the #TGameService instances by #DebugUpdate priorty
		returns:
		about: Used by the TGameEngine instance when adding services the relevant Method TLists
	endrem
	Function DebugUpdatePrioritySort:Int(o1:Object, o2:Object)
		Local o1Priority:Int = TGameService(o1).GetDebugUpdatePriority()
		Local o2Priority:Int = TGameService(o2).GetDebugUpdatePriority()
		Return PrioritySort(o1Priority, o2Priority)
	End Function
	
	
	
	rem
		bbdoc: Compare Function used to sort the #TGameService instances by priorty
		returns: 
		about: Used by the TGameEngine instance when adding services the relevant Method TLists
	endrem
	Function PrioritySort:Int(o1Priority:Int, o2Priority:Int)
		If o1Priority < o2Priority
			Return - 1
		ElseIf o1Priority > o2Priority
			Return 1
		Else
			Return 0
		EndIf
	End Function
	
	
	
	rem
		bbdoc: Compare Function used to sort the #TGameService instances by #Render priorty
		returns:
		about: Used by the TGameEngine instance when adding services the relevant Method TLists
	endrem
	Function RenderPrioritySort:Int(o1:Object, o2:Object)
		Local o1Priority:Int = TGameService(o1).GetRenderPriority()
		Local o2Priority:Int = TGameService(o2).GetRenderPriority()
		Return PrioritySort(o1Priority, o2Priority)
	End Function
	
	
	
	rem
		bbdoc: Shuts down the #TGameService instance
		returns:
		about: This is called by the #TGameEngine instance and also writes
		when it shuts down.  It also writes a LOG_INFO message to the #TGameEngine
		log file.
	endrem		
	Method Shutdown()
		RemoveService(Self)
		TLogger.GetInstance().LogInfo("[" + ToString() + "] Shutdown")
	End Method
	
	
		
	rem
		bbdoc: Compare Function used to sort the #TGameService instances by #Start priorty
		returns:
		about: Used by the TGameEngine instance when adding services the relevant Method TLists
	endrem
	Function StartPrioritySort:Int(o1:Object, o2:Object)
		Local o1Priority:Int = TGameService(o1).GetStartPriority()
		Local o2Priority:Int = TGameService(o2).GetStartPriority()
		Return PrioritySort(o1Priority, o2Priority)
	End Function
	
	
	
	rem
		bbdoc: Returns the name of the TGameService
		returns: String
	endrem
	Method ToString:String()
		Return GetName()
	End Method
	
	
		
	rem
		bbdoc: Compare Function used to sort the #TGameService instances by #Update priorty
		returns:
		about: Used by the TGameEngine instance when adding services the relevant Method TLists
	endrem
	Function UpdatePrioritySort:Int(o1:Object, o2:Object)
		Local o1Priority:Int = TGameService(o1).GetUpdatePriority()
		Local o2Priority:Int = TGameService(o2).GetUpdatePriority()
		Return PrioritySort(o1Priority, o2Priority)
	End Function
			
End Type




