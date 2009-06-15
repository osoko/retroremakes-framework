Type THighScoreTable

	Field maxEntries:Int
	Field Filename:String
	Field cryptKey:String
	
	Field allEntries:THighScoreEntry[]
	
	Function Create:THighScoreTable(hstFile:String = "hiscore.dat", entries:Int = 10)
		Local n:THighScoreTable = New THighScoreTable
		n.maxEntries = entries
		n.Filename = hstFile		
		n.allEntries = New THighScoreEntry[ n.maxEntries ]
		For Local i:Int = 0 To n.maxEntries - 1
			n.allEntries[i] = New THighScoreEntry
		Next
		Return n
	EndFunction

	Method Load:Int()
		If FileType( Filename ) = 1	'File exists
			Local fileHandle:TStream
			If Not cryptKey	
				'load saved high-score table
				fileHandle = ReadFile( Filename )
				For Local i:Int = 0 To maxEntries - 1
					allEntries[ i ].SetScore( Int(ReadLine(fileHandle ) ))
					allEntries[ i ].SetTimePlayed( Long(ReadLine( fileHandle ) ))
					allEntries[ i ].SetPlayerName(ReadLine( fileHandle ) )
				Next
				CloseFile( fileHandle )
			Else
				'load saved high-score table
				Local cryptScore:String
				Local cryptName:String
				Local cryptTimePlayed:String
				Local numShorts:Int
				fileHandle = ReadFile( Filename )
				For Local i:Int = 0 To maxEntries - 1

					numShorts = ReadInt( fileHandle )	'number of characters in the score
					Local scoreArray:Short[ numShorts ]
					For Local x:Int = 0 To numShorts - 1
						scoreArray[x] = ReadShort( fileHandle )
					Next
					cryptScore = String.FromShorts( scoreArray, numShorts )	'convert to string
					cryptScore = rrRC4(cryptScore, cryptKey) 	'decrypt
					allEntries[i].SetScore( cryptScore.ToInt() )
	
					numShorts = ReadInt( fileHandle )
					Local nameArray:Short[ numShorts ]
					For Local x:Int = 0 To numShorts - 1
						nameArray[x] = ReadShort( fileHandle )
					Next				
					cryptName = String.FromShorts( nameArray, numShorts )
					cryptName = rrRC4(cryptName, cryptKey) 
					allEntries[i].SetPlayerName( cryptName )
	
					numShorts = ReadInt( fileHandle )
					Local timeArray:Short[ numShorts ]
					For Local x:Int = 0 To numShorts - 1
						timeArray[x] = ReadShort( fileHandle )
					Next				
					cryptTimePlayed = String.FromShorts( timeArray, numShorts )
					cryptTimePlayed = rrRC4(cryptTimePlayed, cryptKey) 
					allEntries[i].SetTimePlayed( cryptTimePlayed.ToLong() )
				Next
				CloseFile( fileHandle )
			EndIf
		Else
			Return False 'file doesn't exist
		EndIf		
		Return True 'loaded HST
	End Method
	
	Method Save()
		If Not cryptKey
			'save high-score table
			Local fileHandle:TStream = WriteFile( Filename )
			For Local i:Int = 0 To maxEntries - 1
				WriteLine( fileHandle, String(allEntries[ i ].GetScore()) )
				WriteLine( fileHandle, String(allEntries[ i ].GetTimePlayed()) )
				WriteLine( fileHandle, allEntries[ i ].GetPlayerName() )
			Next
			CloseFile( fileHandle )
		Else
			'Save encrypted high-score table
			Local cryptScore:String
			Local cryptName:String
			Local cryptTimePlayed:String
			Local fileHandle:TStream = WriteFile( Filename )

			For Local i:Int = 0 To maxEntries - 1
				cryptScore = rrRC4(String(allEntries[i].GetScore()), cryptKey) 
				cryptName = rrRC4(allEntries[i].GetPlayerName(), cryptKey) 
				cryptTimePlayed = rrRC4(String(allEntries[i].GetTimePlayed()), cryptKey) 
				WriteInt( fileHandle, cryptScore.length )
				For Local x:Int = 0 To cryptScore.length - 1
					WriteShort( fileHandle, Short(cryptScore[x]) )
				Next
				WriteInt( fileHandle, cryptName.length )
				For Local x:Int = 0 To cryptName.length - 1 
					WriteShort( fileHandle, Short(cryptName[x]) )
				Next
				WriteInt( fileHandle, cryptTimePlayed.length )
				For Local x:Int = 0 To cryptTimePlayed.length - 1
					WriteShort( fileHandle, Short( cryptTimePlayed[x]) )
				Next
			Next
			CloseFile( fileHandle )
		EndIf	
	EndMethod
	
	Method AddScore:Int( score:Long, playerName:String, ctime:Long )
		Local Position:Int
		If score > allEntries[ maxEntries - 1 ].Score
			For Local i:Int = 0 To maxEntries - 1
				If score => allEntries[ i ].Score
					Position = i
					Exit
				EndIf
			Next
			Local newPosition:Int = maxEntries - 1
			For Local i:Int = maxEntries - 2 To Position Step - 1
				allEntries[ newPosition ].Score = allEntries[ i ].Score
				allEntries[ newPosition ].playerName = allEntries[ i ].playerName
				allEntries[ newPosition ].timePlayed = allEntries[ i ].timePlayed
				newPosition :- 1
			Next
			allEntries[ Position ].score = score
			allEntries[ Position ].playerName = playerName
			allEntries[ Position ].timePlayed = ctime
			Return Position+1
		Else
			Return 0
		EndIf
	EndMethod
	
	Method ScoreInTable:Int( score:Long )
		If score > allEntries[ maxEntries - 1 ].Score
			Return True
		Else
			Return False
		EndIf
	EndMethod

	Method SetCryptKey( newCryptKey:String )
		cryptKey = newCryptKey
	End Method
	
	Method GetCryptKey:String()
		Return cryptKey
	End Method
	
	Method GetMaxEntries:Int()
		Return maxEntries
	End Method
	
	Method GetHighScoreEntry:THighScoreEntry( Position:Int )
		If Position < 1 Or Position > maxEntries Then Return Null
		Return allEntries[Position-1]
	End Method
EndType