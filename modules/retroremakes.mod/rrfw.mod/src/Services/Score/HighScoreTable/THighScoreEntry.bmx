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