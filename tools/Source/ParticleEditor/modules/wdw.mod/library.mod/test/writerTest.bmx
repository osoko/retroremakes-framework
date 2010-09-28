

Type writerTest Extends TTest

	'use a mock
	Field l:TTestLibrary
	Field o:testobject
	
	Method setup() {before}
		l = New TTestLibrary
		l.SetReader(New TTestReader)
		l.SetWriter(New TTestWriter)
	End Method
	
	
	Method cleanup() {after}
		l = Null
	End Method
	
	
	Method testCreateWriter() {test}
		assertNotNull(l.writer)
	End Method
	
End Type
