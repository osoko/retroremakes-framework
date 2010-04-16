Type floatValueTest Extends TTest

	Field f:TFloatValue
	
	Method Setup() {before}
		f = New TFloatValue
	End Method
	
	Method cleanup() {after}
		f = Null
	End Method	
	
	'can we create a float value
	Method testCreateFloat() {test}
		assertNotNull(f)
	End Method

	'are defaults correct?
	Method testFloatDefaults()
		
	End Method
	
End Type
