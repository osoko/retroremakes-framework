rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type THighScoreEntry
	Field score:Int = 0
	Field playerName:String = ""
	Field timePlayed:Long = 0
	
	Method GetScore:Int()
		Return score
	End Method
	
	Method SetScore( value:Int )
		score = value
	End Method
	
	Method SetPlayerName( value:String )
		playerName = value
	End Method
	
	Method GetPlayerName:String()
		Return playerName
	End Method
	
	Method GetTimePlayed:Long()
		Return timePlayed
	End Method
	
	Method SetTimePlayed( value:Long )
		timePlayed = value
	End Method

EndType