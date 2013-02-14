Rem
'
' Copyright (c) 2007-2011 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

Rem
bbdoc: High-Score Table
about: A High-Score table consists of one or more THighScoreEntry objects
which contain player's scores, names and time played information. They can
be written out to disk in either encrypted (using an RC4 cipher) or
unencypted format.
EndRem
Type THighScoreTable

	Const DEFAULT_FILENAME:String = "hiscore.dat"
	Const DEFAULT_MAX_ENTRIES:Int = 10
	Const DEFAULT_NAME:String = "High-Score Table"
	
	Field _maxEntries:Int
	Field filename:String
	Field cryptKey:String
	
	' The name of this high-score table
	Field _name:string
	
	Field allEntries:THighScoreEntry[]
	
	
	
	Rem
	bbdoc: Creates a high-score table instance
	about: This creates and returns a high-score table with the specified
	filename, maximum number of entries and name
	EndRem
	Function Create:THighScoreTable(filename:String = DEFAULT_FILENAME, entries:Int = DEFAULT_MAX_ENTRIES, name:String = DEFAULT_NAME)
		Local n:THighScoreTable = New THighScoreTable
		n.SetMaxEntries (entries)
		n.SetFilename (filename)
		n.SetName (name)
		Return n
	End Function

	
	
	Rem
	bbdoc: Returns an array containing all THighScoreTableEntry objects in this
	high-score table
	EndRem
	Method GetEntries:THighScoreEntry[] ()
		Return allEntries	
	End Method
	
	
	
	Rem
	bbdoc: Returns the filename to be used when writing this high-score table
	EndRem
	Method GetFilename:String()
		Return filename
	End Method
	
	

	Rem
	bbdoc: Returns the maximum number of entries in this table
	EndRem
	Method GetMaxEntries:Int()
		Return _maxEntries
	End Method
	
	
			
	Rem
	bbdoc: Returns the name of this high-score table
	EndRem
	Method GetName:String()
		Return _name
	End Method
	
	

	Rem
	bbdoc: Initialises the array of THighScoreEntry objects to the correct size
	EndRem
	Method InitialiseEntries()
		allEntries = New THighScoreEntry [_maxEntries]
		For Local i:Int = 0 To _maxEntries - 1
		        allEntries[i] = New THighScoreEntry
		Next
	End Method
	
	
	
	Rem
	bbdoc: Resizes the array of THighScoreEntry objects if the Max Entries value
	has been modified
	EndRem
	Method ResizeEntries()
		allEntries = allEntries [.._maxEntries]
		For Local i:Int = 0 to _maxEntries - 1
			if Not allEntries [i]
				allEntries [i] = New THighScoreEntry
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets the filename to ve used when reading/writing this high-score table
	EndRem
	Method SetFilename (filename:String)
		Self.filename = filename
	End Method
	
	
	
	Rem
	bbdoc: Sets the maximum amount of entries to the value specified
	EndRem
	Method SetMaxEntries (maxEntries:Int)
		_maxEntries = maxEntries
		
		If Not GetEntries()
			InitialiseEntries()
		Else
			ResizeEntries()
		End If
	End Method
	

		
	Rem
	bbdoc: Sets the name of this high-score table
	EndRem
	Method SetName (name:String)
		_name = name
	End Method
	
	
	
	Rem
	bbdoc: Attempts to load the high-score table from disk
	returns: True if succeeded, otherwise False
	EndRem
	Method Load:Int()
		Local succeeded:Int = True
		
		Local filename:String = GetFilename()
		
		If FileType (filename) = FILETYPE_FILE
			Local stream:TStream = ReadFile (filename)
			
			If stream
				If GetCryptKey()
					succeeded = LoadEncrypted (stream)
				Else
					succeeded = LoadUnencrypted (stream)
				EndIf	
				CloseFile (stream)
			Else
				'faled to open file for reading
				succeeded = False
			EndIf
		Else
			'file doesn't exist
			succeeded = False
		EndIf	
			
		Return succeeded
	End Method
	
	

	Rem
	bbdoc: Attempts to load an encrypted table from the specified stream
	EndRem
	Method LoadEncrypted:Int (stream:TStream)
		'TODO: Add error checking
		Local data:String
		Local numShorts:Int
		Local shortArray:Short[]


		For Local i:Int = 0 To _maxEntries - 1
			Local score:Long
			Local timePlayed:Long
			Local name:String
			
			'read and decrypt the score
			numShorts = ReadInt (stream)
			shortArray = New Short [numShorts]
			For Local x:Int = 0 To numShorts - 1
				shortArray [x] = ReadShort (stream)
			Next
			data = String.FromShorts (shortArray, numShorts)
			data = RC4 (data, cryptKey)
			score = data.ToLong()
						
			'read and decrypt the name
			numShorts = ReadInt (stream)
			shortArray = New Short [numShorts]
			For Local x:Int = 0 To numShorts - 1
				shortArray [x] = ReadShort (stream)
			Next				
			data = String.FromShorts (shortArray, numShorts)
			name = RC4 (data, cryptKey) 
	
			'read and decrypt the time played
			numShorts = ReadInt( stream )
			shortArray = New Short [numShorts]
			For Local x:Int = 0 To numShorts - 1
				shortArray [x] = ReadShort (stream)
			Next				
			data = String.FromShorts (shortArray, numShorts)
			data = RC4 (data, cryptKey) 
			timePlayed = data.ToLong()
			
			' Finally set the entry
			allEntries [i].SetScore (score)
			allEntries [i].SetPlayerName (name)
			allEntries [i].SetTimePlayed (timePlayed)
		Next
		
		Return True
	End Method
	
	
	
	Rem
	bbdoc: Attempts to load an unencrypted table from the specified stream
	EndRem
	Method LoadUnencrypted:Int (stream:TStream)
		'TODO: Add error checking
		Local score:Long
		Local time:Long
		Local name:String
		For Local i:Int = 0 To _maxEntries - 1
			score = Long (ReadLine (stream))
			time = Long (ReadLine (stream))
			name = ReadLine (stream) 
			
			allEntries [i].SetScore (score)
			allEntries [i].SetTimePlayed (time)
			allEntries [i].SetPlayerName (name)
		Next
		Return True
	End Method
	
	
	
	Method Save()
		If Not cryptKey
			'save high-score table
			Local fileHandle:TStream = WriteFile( Filename )
			For Local i:Int = 0 To _maxEntries - 1
				WriteLine( fileHandle, String(allEntries[ i ].GetScore()) )
				WriteLine( fileHandle, String(allEntries[ i ].GetTimePlayed()) )
				WriteLine( fileHandle, allEntries[ i ].GetPlayerName() )
			Next
			CloseFile(fileHandle)
		Else
			'Save encrypted high-score table
			Local cryptScore:String
			Local cryptName:String
			Local cryptTimePlayed:String
			Local fileHandle:TStream = WriteFile( Filename )

			For Local i:Int = 0 To (GetMaxEntries() - 1)
				cryptScore = RC4(String(allEntries[i].GetScore()), cryptKey) 
				cryptName = RC4(allEntries[i].GetPlayerName(), cryptKey) 
				cryptTimePlayed = RC4(String(allEntries[i].GetTimePlayed()), cryptKey) 
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
	
	Method AddScore:Int (score:Long, playerName:String, ctime:Long)
		Local position:Int
		If score > allEntries [_maxEntries - 1].GetScore()
			For Local i:Int = 0 To _maxEntries - 1
				If score >= allEntries [i].GetScore()
					Position = i
					Exit
				EndIf
			Next
			Local newPosition:Int = _maxEntries - 1
			For Local i:Int = _maxEntries - 2 To Position Step - 1
				allEntries [newPosition].SetScore (allEntries [i].GetScore())
				allEntries [newPosition].SetPlayerName (allEntries [i].GetPlayerName())
				allEntries [newPosition].SetTimePlayed (allEntries [i].GetTimePlayed())
				newPosition :- 1
			Next
			allEntries [Position].SetScore (score)
			allEntries [Position].SetPlayerName (playerName)
			allEntries [Position].SetTimePlayed (ctime)
			Return Position + 1
		Else
			Return 0
		EndIf
	EndMethod
	
	
	
	Method ScoreInTable:Int (score:Long)
		If score > allEntries [_maxEntries - 1].GetScore()
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
	

	
	Method GetHighScoreEntry:THighScoreEntry( Position:Int )
		If Position < 1 Or Position > _maxEntries
			Return Null
		Else
			Return allEntries[Position-1]
		Endif
	End Method
	
EndType
