rem
	bbdoc: Type description
end rem
Type TCircleTests Extends TTest
	
	Method _setup() {before}
	End Method
	
	Method _teardown() {after}
	End Method
	
	Method CanInstantiateCircle() {test}
		Local circle:TCircle = New TCircle
		assertNotNull(circle)
	End Method

	Method OverlappingCirclesReturnsFalseWhenNotOverlapping() {test}
		Local c1:TCircle = New TCircle
		assertNotNull(c1)
		c1.c.x = 0.0
		c1.c.y = 0.0
		c1.r   = 10.0
		
		Local c2:TCircle = New TCircle
		assertNotNull(c2)			
		c2.c.x = 20.1
		c2.c.y = 0.0
		c2.r   = 10.0

		assertFalse (c1.Overlaps (c2))
	End Method
		
	Method OverlappingCirclesReturnsTrueWhenOverlapping() {test}
		Local c1:TCircle = New TCircle
		assertNotNull(c1)
		c1.c.x = 0.0
		c1.c.y = 0.0
		c1.r   = 10.0
		
		Local c2:TCircle = New TCircle
		assertNotNull(c2)			
		c2.c.x = 4.6
		c2.c.y = 7.8
		c2.r   = 10.0

		assertTrue (c1.Overlaps (c2))		
	End Method
End Type
