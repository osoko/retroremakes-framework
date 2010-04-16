'contains tests for value, float, and color values

Type valueTest Extends TTest

	'use a mock because tvalue is abstract and has abstract methods
	Field v:TValueMOCK
	
	Method setup() {before}
		v = New TValueMOCK
	End Method
	
	Method cleanup() {after}
		v = Null
	End Method
	
	' Can we create a TValue?
	Method testCreateValue() {test}
		assertNotNull(v)
	End Method
	
	' Can we set the behaviour?
	Method testSetBehaviour() {test}
		v.SetBehaviour(BEHAVIOUR_ONCE)
		assertEqualsI(BEHAVIOUR_ONCE, v.GetBehaviour())
	End Method
	
	'can we enable the value
	Method testSetActive() {test}
		v.SetActive(True)
		assertEquals(True, v.GetActive())
	End Method
	
	'can we set the mode of the value
	Method testSetMode() {test}
		v.SetMode(RUNNING)
		assertEquals(RUNNING, v.GetMode())
	End Method
	
	'can we alter the amount by which the value changes?
	Method testSetChangeAmount()
		v.SetChangeAmount(2.0)
		assertEqualsF(2.0, v.GetChangeAmount())
	End Method

End Type


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
		assertNotNull(v)
	End Method

	'are defaults correct?
	Method testFloatDefaults()
		
	End Method
	
End Type



Type TValueMOCK Extends TValue
	
	Method UpdateValue:Int()
	End Method

	Method ResetValue()
	End Method
		
	Method ReverseChange()
	End Method

	Method SetPrevious()
	End Method

End Type