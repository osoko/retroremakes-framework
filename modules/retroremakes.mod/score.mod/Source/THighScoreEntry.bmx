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
bbdoc: High-Score Table Entry class
about: This Type contains a player's name, score and the length of time they
played the game which resulted in this score.
EndRem
Type THighScoreEntry

	' The player's name
	Field _playerName:String
	
	' The player's score
	Field _score:Long
	
	' The length of time played in milliseconds
	Field _timePlayed:Long
	
	
	Rem
	bbdoc: Get the player name for this high-score entry
	EndRem
	Method GetPlayerName:String()
		Return _playerName
	End Method

	
			
	Rem
	bbdoc: Get the score value of this high-score entry
	EndRem
	Method GetScore:Long()
		Return _score
	End Method

	
	
	Rem
	bbdoc: Gets the length of time played for this high-score entry
	about: Returned value is in milliseconds
	EndRem
	Method GetTimePlayed:Long()
		Return _timePlayed
	End Method



	Rem
	bbdoc: Sets the player name for this high-score entry
	EndRem
	Method SetPlayerName (value:String)
		_playerName = value
	End Method

	
	
	Rem
	bbdoc: Sets the high-score entry score to the specified value
	EndRem
	Method SetScore (value:Long)
		_score = value
	End Method
	
	
	
	Rem
	bbdoc: Sets the time played for this high-score entry
	about: value is in milliseconds
	EndRem
	Method SetTimePlayed (value:Long)
		_timePlayed = value
	End Method

EndType
