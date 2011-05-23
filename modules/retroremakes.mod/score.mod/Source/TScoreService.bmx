rem
'
' Copyright (c) 2007-2011 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TScoreService Extends TGameService

	Global instance:TScoreService		' This holds the singleton instance of this Type
	
	Field LScores:TList = New TList	' List containing all currently running scores
	
	Field highScoreTable:THighScoreTable
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
		SetName("Score Service")
		Super.Initialise()  'Call TGameService initialisation routines
	End Method

	Method Shutdown()
		If highScoreTable
			highScoreTable.Save()
		EndIf
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method
	
	Method CreateHighScoreTable(fileName:String = "hiscore.dat", nEntries:Int = 10)
		Local dataDir:String = TGameEngine.GetInstance().GetGameDataDirectory()
		highScoreTable = THighScoreTable.Create(dataDir + fileName, nEntries)
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
		If Not highScoreTable
			CreateHighScoreTable()
		End If
		Return highScoreTable
	End Method
EndType
