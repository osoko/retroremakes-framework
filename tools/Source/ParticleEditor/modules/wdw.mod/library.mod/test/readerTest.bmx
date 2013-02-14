

Type readerTest Extends TTest

	'use a mock
	Field l:TTestLibrary
	
	Method setup() {before}
		l = New TTestLibrary
		l.SetReader(New TTestReader)
	End Method
	
	
	Method cleanup() {after}
		l = Null
	End Method
	
	
	Method testCreateLoader() {test}
		assertNotNull(l.reader)
	End Method
	
	
	Method testLoadLibraryFail() {test}
		Local result:Int = l.ReadConfiguration("mocks/notexist.txt")
		assertFalse(result)
	End Method
	
	
	Method testLoadLibrary() {test}
		Local result:Int = l.ReadConfiguration("mocks/mockLib.txt")
		assertTrue(result)
	End Method
	
	
	Method testRetrievalFail() {test}
		Local result:Int = l.ReadConfiguration("mocks/mockLib.txt")
		assertTrue(result)

		'non existant
		Local test:testObject = testObject(l.GetObject(20))
		assertNull(test)
	End Method


	Method testRetrieval() {test}
		Local result:Int = l.ReadConfiguration("mocks/mockLib.txt")
		assertTrue(result)
		
		'exists!
		Local test:testObject = testObject(l.GetObject(10))
		assertNotNull(test)
	End Method
	

	Method testIDchange() {test}
		Local result:Int = l.ReadConfiguration("mocks/mockLib.txt")
		assertTrue(result)
		
		'loaded test object has id 10. next ID should be 11
		assertEqualsI(11, l.nextID)
	End Method
	
		
End Type
