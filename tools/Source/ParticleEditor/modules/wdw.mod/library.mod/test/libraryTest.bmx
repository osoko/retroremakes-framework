

Type libraryTest Extends TTest

	'use a mock
	Field t:TTestLibrary
	
	Method setup() {before}
		t = New TTestLibrary
	End Method
	
	Method cleanup() {after}
		t = Null
	End Method
	
	
	
	Method testCreateLibrary() {test}
		assertNotNull(t)
	End Method
	
	
	
	Method testAddObject() {test}
		Local o:testObject = New testobject
		Local o1:testObject = New testObject
		t.AddObject(o)
		assertTrue(t.ContainsObject(o))
		
		assertFalse(t.ContainsObject(o1))
	End Method



	Method testRemoveObject() {test}
		Local o:testObject = New testobject
		t.AddObject(o)
		assertTrue(t.ContainsObject(o))
		
		t.RemoveObject(o)
		assertFalse(t.ContainsObject(o))
	End Method

	

	Method testRemoveObjectByID() {test}
		Local o:testObject = New testobject
		Local id:Int = t.AddObject(o)
		assertTrue(t.ContainsObject(o))
		
		t.RemoveObjectbyID(id)
		assertFalse(t.ContainsObject(o))
	End Method
	
	
	
	Method testGetNewID() {test}
		Local id:Int = t.getnewID()
		Local id2:Int = t.GetNewID()
		assertEqualsI(id + 1, id2)
		
		Local id3:Int = t.getnewid()
		assertEqualsI(id2 + 1, id3)
	End Method
	
	
	
	Method testClear() {test}
		Local o:testObject = New testobject
		t.AddObject(o)
		assertTrue(t.ContainsObject(o))
		
		t.Clear()
		
		assertFalse(t.ContainsObject(o))
		assertEqualsI(t.GetNewID(), 1)
	
	End Method
	
	
	
End Type
