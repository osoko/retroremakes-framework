rem
	bbdoc: TGameState
	about: 
endrem
Type TGameState
	
	rem
		bbdoc: TLink used by TGameStateManager.
		about:
	endrem
	Field link:TLink

	
		
	rem
		bbdoc: Initialises the Game State
		returns:
		about: This method is called for all instances of TGameState when TGameEngine
		starts running.  The Graphics device has been created by this time.
	endrem
	Method Initialise()
	End Method

	
	
	rem
		bbdoc: Renders the Game State
		returns:
		about: This method is called for the current TGameState
		instance by the main TGameEngine Render loop.
	endrem		
	Method Render()
	End Method
	
	
		
	rem
		bbdoc: Enter the Game State
		returns:
		about: This method is called when you switch to this TGameState
		instance.
	endrem
	Method Enter()
	End Method
	
	

	rem
		bbdoc: Shutdown the Game State
		returns:
		about: This method is called for each TGameState instance
		when the TGameEngine is shutting down.
	endrem			
	Method Shutdown()
	End Method


	
	
	rem
		bbdoc: Leave the Game State
		returns:
		about: This method is called when you switch to another TGameState
		instance.
	endrem	
	Method Leave()
	End Method
	


	rem
		bbdoc: Updates the Game State
		returns:
		about: This method is called for the current TGameState
		instance by the main TGameEngine Update loop.
	endrem		
	Method Update()
	End Method
	
End Type
