' Unit Tests for the THighScoreEntry Type
Type THighScoreEntryTests Extends TTest

	Field entry:THighScoreEntry
	
	Method _setup() {before}
		entry = New THighScoreEntry
	End Method
	
	Method CanInsantiateEntry() {test}
		assertNotNull (New THighScoreEntry)
	End Method
	
	Method CanSetScore() {test}
		entry.SetScore (987654321:Long)
		assertEqualsL (987654321:Long, entry._score)
	End Method
	
	Method CanGetScore() {test}
		entry.SetScore (123456789:Long)
		assertEqualsL (123456789:Long, entry.GetScore())
	End Method
	
	Method CanSetPlayerName() {test}
		entry.SetPlayerName ("John Doe")
		assertEquals ("John Doe", entry._playerName)
	End Method
	
	Method CanGetPlayerName() {test}
		entry.SetPlayerName ("Roger Rabbit")
		assertEquals ("Roger Rabbit", entry.GetPlayerName())
	End Method
	
	Method CanSetTimePlayed() {test}
		entry.SetTimePlayed (223344:Long)
		assertEqualsL (223344:Long, entry._timePlayed)
	End Method
	
	Method CanGetTimePlayed() {test}
		entry.SetTimePlayed (4729373875:Long)
		assertEqualsL (4729373875:Long, entry.GetTimePlayed())
	End Method
	
End Type
