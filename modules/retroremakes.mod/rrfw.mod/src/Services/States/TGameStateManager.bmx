rem
	bbdoc: TGameStateManager
	about: TGameStateManager is a TGameService which handles registering and
	switching between TGameStates.
endrem
Type TGameStateManager Extends TGameService

	rem
		bbdoc: The TGameStateManager instance
		about: TGameStateManager is a Singleton Type
	endrem
	Global instance:TGameStateManager

	
	rem
		bbdoc: The currently active TGameState.
		about:
	endrem
	Field currentState:TGameState
	
	
	rem
		bbdoc: TList containing all registered TGameStates.
		about:
	endrem	
	Field gameStates:TList

	
	rem
		bbdoc: Whether to loop TGameStates or not
		about: This allows you to loop forwards or backwards through all TGameStates
		using the NextGameState() and PreviousGameState() methods.  Default setting
		is to not loop, in which case the Engine will be shutdown once all
		TGameStates have been used (good for demos, etc.)
	endrem	
	Field loopStates:Int = False

	
	
	Method AddGameState(state:TGameState)
		If state.link Then Throw "You cannot add a game state more than once"
		state.link = gameStates.AddLast(state)
	End Method
	
	
		
	Method DeleteGameState(State:TGameState)
		If Not State.link Then Throw "You cannot delete a game state that hasn't been added"
		State.Shutdown()
		gameStates.Remove(State)
	End Method
	
	
		
	Function GetInstance:TGameStateManager()
		If Not instance
			Return New TGameStateManager
		Else
			Return instance
		EndIf
	EndFunction
	
	
	
	Method GetLoopStates:Int()
		Return loopStates
	End Method
	
	
			
	Method Initialise()
		SetName("State Manager")
		gameStates = New TList
		Super.Initialise()  'Call TGameService initialisation routines
	End Method
	
	
				
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	

	Method NextGameState()
		If currentState.link.NextLink()
			SetGameState(TGameState(currentState.link.NextLink().Value()))
		Else
			If loopStates
				SetGameState(TGameState(gameStates.First()))
			Else
				rrEngineStop()
			End If
		End If
	End Method
	
	
	
	Method PreviousGameState()
		If currentState.link.PrevLink()
			SetGameState(TGameState(currentState.link.PrevLink().Value()))
		Else
			If loopStates
				SetGameState(TGameState(gameStates.Last()))
			Else
				rrEngineStop()
			End If
		End If
	End Method
	
	
			
	Method Render()
		If Not currentState Then Return
		currentState.Render()
	End Method
	
	
	
	Method SetGameState(state:TGameState)
		If currentState Then currentState.Leave()
		currentState = state
		currentState.Enter()
	End Method
	
	
		
	Method SetLoopStates(Loop:Int = True)
		loopStates = Loop
	End Method
	
	
				
	Method Shutdown()
		For Local state:TGameState = EachIn gameStates
			state.Shutdown()
			gameStates.Remove(state)
		Next
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method

	
		
	Method Start()
		'Run Start Method of all registered TStates
		For Local state:TGameState = EachIn gameStates
			state.Initialise()
		Next
	End Method

	
		
	Method Update()
		If Not currentState
			If gameStates.Count() > 0
				currentState = TGameState(gameStates.First())
				currentState.Enter()
			Else
				Return
			End If
		EndIf
		currentState.Update()
	End Method

EndType

Function rrAddGameState(state:TGameState)
	TGameStateManager.GetInstance().AddGameState(state)
End Function

Function rrDeleteGameState(State:TGameState)
	TGameStateManager.GetInstance().DeleteGameState(State)
End Function

Function rrSetGameState(state:TGameState)
	TGameStateManager.GetInstance().SetGameState(state)
End Function

Function rrNextGameState()
	TGameStateManager.GetInstance().NextGameState()
End Function

Function rrPreviousGameState()
	TGameStateManager.GetInstance().PreviousGameState()
End Function

Function rrSetLoopStates(Loop:Int = True)
	TGameStateManager.GetInstance().SetLoopStates(Loop)
End Function

Function rrGetLoopStates:Int()
	Return TGameStateManager.GetInstance().GetLoopStates()
End Function