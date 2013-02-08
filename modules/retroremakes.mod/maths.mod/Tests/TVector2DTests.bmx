Type TVector2DTests Extends TTest
	
	Const EPSILON :Float = 0.0001
	
	Field v1 :TVector2D
	Field v2 :TVector2D
	
	Method _setup() {before}
		v1 = TVector2D.Create()
		v2 = TVector2D.Create()
	End Method
	
	Method _teardown() {after}
	End Method
	
	Method VectorCorrectAfterCreate() {test}
		Local v:TVector2D = TVector2D.Create(12.3, 45.6)
		assertNotNull (v)
		assertEqualsF (12.3, v.x, EPSILON, "x value not correct")
		assertEqualsF (45.6, v.y, EPSILON, "y value not correct")
	End Method
	
	Method VectorCorrectAfterCreateWithDefaultValues() {test}
		Local v:TVector2D = TVector2D.Create()
		assertNotNull (v)
		assertEqualsF (0.0, v.x, EPSILON, "x value not correct")
		assertEqualsF (0.0, v.y, EPSILON, "y value not correct")
	End Method	
	
	Method VectorCorrectAfterNew() {test}
		Local v:TVector2D = New TVector2D
		assertNotNull (v)
		assertEqualsF (0.0, v.x, EPSILON, "x value not correct")
		assertEqualsF (0.0, v.y, EPSILON, "y value not correct")
	End Method
	
EndType
