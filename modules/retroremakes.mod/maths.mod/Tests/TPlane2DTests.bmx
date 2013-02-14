rem
	bbdoc: Type description
end rem
Type TPlane2DTests Extends TTest
	
	Method _setup() {before}
	End Method
	
	Method _teardown() {after}
	End Method

	Method CanInstantiatePlaneWithNew() {test}
		Local plane:TPlane2D = New TPlane2D
		assertNotNull (plane)
	End Method
	
	Method CanInstantiatePlaneWithNormalAndPoint() {test}
		Local normal   :TVector2D = TVector2D.Create (0.0, -1.0)
		Local position :TVector2D = TVector2D.Create (1.0,  1.0)

		Local plane :TPlane2D = TPlane2D.Create (normal, position)
		assertNotNull (plane)
	End Method
	
	Method FacingPlaneDetectedCorrectly() {test}
		Local normal   :TVector2D = TVector2D.Create (0.0, -1.0)
		Local position :TVector2D = TVector2D.Create (1.0,  1.0)
		
		Local plane :TPlane2D = TPlane2D.Create (normal, position)	
			
		Local lookVector1 :TVector2D = TVector2D.Create (-0.5, 1.0)
		lookVector1.Normalise()
		assertTrue (plane.IsFacing (lookVector1))
		
		Local lookVector2 :TVector2D = TVector2D.Create (1.5, -0.5)
		lookVector2.Normalise()
		assertFalse (plane.IsFacing (lookVector2))
	End Method
	
End Type
