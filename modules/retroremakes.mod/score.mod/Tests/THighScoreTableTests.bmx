' Unit Tests for the THighScoreTable Type
Type THighScoreTableTests extends TTest

	Field table:THighScoreTable
	
	Method _setup() {before}
		table = THighScoreTable.Create()
	End Method
	
	Method CanCreateHighScoreTable() {test}
		assertNotNull (table)
	End Method
	
	Method CanGetFilename() {test}
		assertEquals (THighScoreTable.DEFAULT_FILENAME, table.GetFilename())	
	End Method
	
	Method CanGetName() {test}
		assertEquals (THighScoreTable.DEFAULT_NAME, table.GetName())
	End Method
	
	Method CanGetMaxEntries() {test}
		assertEqualsI (THighScoreTable.DEFAULT_MAX_ENTRIES, table.GetMaxEntries())
	End Method
	
EndType
