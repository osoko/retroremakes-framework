Type TWorldManager Extends TGameService

	Global instance:TWorldManager		' This holds the singleton instance of this Type
	
	Field worldSize:TVector2D			' The size of the game world
	Field worldOffset:TVector2D		' Offset used for the current view of the world

	Field displaySize:TVector2D		' The size of either the screen resolution or projection matrix (if used)
	
'	Field mapEngine:TMapEngine			' This is the holder for the current map Engine
		
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TWorldManager()
		Return TWorldManager.GetInstance()
	End Function
	
	Function GetInstance:TWorldManager()
		If Not instance
			Return New TWorldManager
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		Self.name = "World Manager"
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Start()
		displaySize = rrGetGraphicsSize()
	End Method
	
	Method Update()
		'TODO
	End Method
	
	Method Shutdown()
		'TODO
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
EndType
