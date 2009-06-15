Type TScoreService Extends TGameService

	Global instance:TScoreService		' This holds the singleton instance of this Type
	
	Field LScores:TList = New TList	' List containing all currently running scores
	
	Field highScoreTable_:THighScoreTable
	Field paused:Int
		
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TScoreService()
		Return TScoreService.GetInstance()
	End Function
	
	Function GetInstance:TScoreService()
		If Not instance
			Return New TScoreService
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 

	Method Initialise()
		Self.name = "Score Service"
	'	Local dataDir:String = TGameEngine.GetInstance().GetDataDirectory()
		'highScoreTable_ = THighScoreTable.Create(dataDir + "hiscore.dat")
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Shutdown()
		If highScoreTable_
			highScoreTable_.Save()
		EndIf
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
	Method CreateHighScoreTable(fileName:String = "hiscore.dat", nEntries:Int = 10)
		Local dataDir:String = TGameEngine.GetInstance().GetDataDirectory()
		highScoreTable_ = THighScoreTable.Create(dataDir + fileName, nEntries)
	End Method
	
	Method Update()
		If TGameEngine.GetInstance().GetPaused()
			If Not paused
				Pause()
				paused = True
			End If
		Else
			If paused
				Unpause()
				paused = False
			EndIf
			For Local score:TScore = EachIn LScores
				score.Update()
			Next
		End If
	End Method
	
	Method Pause()
		For Local score:TScore = EachIn LScores
			score.Pause()
		Next		
	End Method
	
	Method Unpause()
		For Local score:TScore = EachIn LScores
			score.Unpause()
		Next			
	End Method
	
	Method AddScore(score:TScore)
		ListAddLast(LScores, score)
	End Method
	
	Method GetHighScoreTable:THighScoreTable()
		If Not highScoreTable_
			CreateHighScoreTable()
		End If
		Return highScoreTable_
	End Method
EndType
