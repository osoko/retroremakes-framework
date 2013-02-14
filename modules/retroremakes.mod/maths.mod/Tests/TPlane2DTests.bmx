rem
	bbdoc: Type description
end rem
Type TPlane2DTests Extends TTest
	
	Field nLookVector  :TVector2D
	Field neLookVector :TVector2D
	Field eLookVector  :TVector2D
	Field seLookVector :TVector2D
	Field sLookVector  :TVector2D
	Field swLookVector :TVector2D
	Field wLookVector  :TVector2D
	Field nwLookVector :TVector2D

	
	Method _setup() {before}
		nLookVector  = TVector2D.Create ( 0.0, -1.0).Normalise()
		neLookVector = TVector2D.Create ( 1.0, -1.0).Normalise()
		eLookVector  = TVector2D.Create ( 1.0,  0.0).Normalise()
		seLookVector = TVector2D.Create ( 1.0,  1.0).Normalise()
		sLookVector  = TVector2D.Create ( 0.0,  1.0).Normalise()
		swLookVector = TVector2D.Create (-1.0,  1.0).Normalise()
		wLookVector  = TVector2D.Create (-1.0,  0.0).Normalise()
		nwLookVector = TVector2D.Create (-1.0, -1.0).Normalise()
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
	
	
	Method NorthFacingPlaneIsFacingDetectedCorrectly() {test}
		Local nPlane  :TPlane2D = TPlane2D.Create (TVector2D.Create ( 0.0, -1.0), New TVector2D)
	
		assertFalse (nPlane.IsFacing (nLookVector),  "N facing plane, looking N")
		assertFalse (nPlane.IsFacing (neLookVector), "N facing plane, looking NE")
		assertFalse (nPlane.IsFacing (eLookVector),  "N facing plane, looking E")
		assertTrue  (nPlane.IsFacing (seLookVector), "N facing plane, looking SE")
		assertTrue  (nPlane.IsFacing (sLookVector),  "N facing plane, looking S")
		assertTrue  (nPlane.IsFacing (swLookVector), "N facing plane, looking SW")		
		assertFalse (nPlane.IsFacing (wLookVector),  "N facing plane, looking W")
		assertFalse (nPlane.IsFacing (nwLookVector), "N facing plane, looking NW")				
	End Method
	
	
	Method NorthEastFacingPlaneIsFacingDetectedCorrectly() {test}
		Local nePlane :TPlane2D = TPlane2D.Create (TVector2D.Create ( 1.0, -1.0), New TVector2D)
		
		assertFalse (nePlane.IsFacing (nLookVector),  "NE facing plane, looking N")
		assertFalse (nePlane.IsFacing (neLookVector), "NE facing plane, looking NE")
		assertFalse (nePlane.IsFacing (eLookVector),  "NE facing plane, looking E")
		assertFalse (nePlane.IsFacing (seLookVector), "NE facing plane, looking SE")
		assertTrue  (nePlane.IsFacing (sLookVector),  "NE facing plane, looking S")
		assertTrue  (nePlane.IsFacing (swLookVector), "NE facing plane, looking SW")		
		assertTrue  (nePlane.IsFacing (wLookVector),  "NE facing plane, looking W")
		assertFalse (nePlane.IsFacing (nwLookVector), "NE facing plane, looking NW")	
	End Method
	
	
	Method EastFacingPlaneIsFacingDetectedCorrectly() {test}
		Local ePlane  :TPlane2D = TPlane2D.Create (TVector2D.Create ( 1.0,  0.0), New TVector2D)

		assertFalse (ePlane.IsFacing (nLookVector),  "E facing plane, looking N")
		assertFalse (ePlane.IsFacing (neLookVector), "E facing plane, looking NE")
		assertFalse (ePlane.IsFacing (eLookVector),  "E facing plane, looking E")
		assertFalse (ePlane.IsFacing (seLookVector), "E facing plane, looking SE")
		assertFalse (ePlane.IsFacing (sLookVector),  "E facing plane, looking S")
		assertTrue  (ePlane.IsFacing (swLookVector), "E facing plane, looking SW")		
		assertTrue  (ePlane.IsFacing (wLookVector),  "E facing plane, looking W")
		assertTrue  (ePlane.IsFacing (nwLookVector), "E facing plane, looking NW")	
	End Method
	
	
	Method SouthEastFacingPlaneIsFacingDetectedCorrectly() {test}
		Local sePlane :TPlane2D = TPlane2D.Create (TVector2D.Create ( 1.0,  1.0), New TVector2D)

		assertTrue  (sePlane.IsFacing (nLookVector),  "SE facing plane, looking N")
		assertFalse (sePlane.IsFacing (neLookVector), "SE facing plane, looking NE")
		assertFalse (sePlane.IsFacing (eLookVector),  "SE facing plane, looking E")
		assertFalse (sePlane.IsFacing (seLookVector), "SE facing plane, looking SE")
		assertFalse (sePlane.IsFacing (sLookVector),  "SE facing plane, looking S")
		assertFalse (sePlane.IsFacing (swLookVector), "SE facing plane, looking SW")		
		assertTrue  (sePlane.IsFacing (wLookVector),  "SE facing plane, looking W")
		assertTrue  (sePlane.IsFacing (nwLookVector), "SE facing plane, looking NW")			
	End Method
	
	
	Method SouthFacingPlaneIsFacingDetectedCorrectly() {test}
		Local sPlane  :TPlane2D = TPlane2D.Create (TVector2D.Create ( 0.0,  1.0), New TVector2D)

		assertTrue  (sPlane.IsFacing (nLookVector),  "S facing plane, looking N")
		assertTrue  (sPlane.IsFacing (neLookVector), "S facing plane, looking NE")
		assertFalse (sPlane.IsFacing (eLookVector),  "S facing plane, looking E")
		assertFalse (sPlane.IsFacing (seLookVector), "S facing plane, looking SE")
		assertFalse (sPlane.IsFacing (sLookVector),  "S facing plane, looking S")
		assertFalse (sPlane.IsFacing (swLookVector), "S facing plane, looking SW")			
		assertFalse (sPlane.IsFacing (wLookVector),  "S facing plane, looking W")
		assertTrue  (sPlane.IsFacing (nwLookVector), "S facing plane, looking NW")		
	End Method
	
	
	Method SouthWestFacingPlaneIsFacingDetectedCorrectly() {test}
		Local swPlane :TPlane2D = TPlane2D.Create (TVector2D.Create (-1.0,  1.0), New TVector2D)

		assertTrue  (swPlane.IsFacing (nLookVector),  "SW facing plane, looking N")
		assertTrue  (swPlane.IsFacing (neLookVector), "SW facing plane, looking NE")
		assertTrue  (swPlane.IsFacing (eLookVector),  "SW facing plane, looking E")
		assertFalse (swPlane.IsFacing (seLookVector), "SW facing plane, looking SE")
		assertFalse (swPlane.IsFacing (sLookVector),  "SW facing plane, looking S")
		assertFalse (swPlane.IsFacing (swLookVector), "SW facing plane, looking SW")		
		assertFalse (swPlane.IsFacing (wLookVector),  "SW facing plane, looking W")
		assertFalse (swPlane.IsFacing (nwLookVector), "SW facing plane, looking NW")			
	End Method		
	
	
	Method WestFacingPlaneIsFacingDetectedCorrectly() {test}
		Local wPlane  :TPlane2D = TPlane2D.Create (TVector2D.Create (-1.0,  0.0), New TVector2D)

		assertFalse (wPlane.IsFacing (nLookVector),  "W facing plane, looking N")
		assertTrue  (wPlane.IsFacing (neLookVector), "W facing plane, looking NE")
		assertTrue  (wPlane.IsFacing (eLookVector),  "W facing plane, looking E")
		assertTrue  (wPlane.IsFacing (seLookVector), "W facing plane, looking SE")
		assertFalse (wPlane.IsFacing (sLookVector),  "W facing plane, looking S")
		assertFalse (wPlane.IsFacing (swLookVector), "W facing plane, looking SW")		
		assertFalse (wPlane.IsFacing (wLookVector),  "W facing plane, looking W")
		assertFalse (wPlane.IsFacing (nwLookVector), "W facing plane, looking NW")
	End Method
	
	
	Method NorthWestFacingPlaneIsFacingDetectedCorrectly() {test}
		Local nwPlane :TPlane2D = TPlane2D.Create (TVector2D.Create (-1.0, -1.0), New TVector2D)

		assertFalse (nwPlane.IsFacing (nLookVector),  "NW facing plane, looking N")
		assertFalse (nwPlane.IsFacing (neLookVector), "NW facing plane, looking NE")
		assertTrue  (nwPlane.IsFacing (eLookVector),  "NW facing plane, looking E")
		assertTrue  (nwPlane.IsFacing (seLookVector), "NW facing plane, looking SE")
		assertTrue  (nwPlane.IsFacing (sLookVector),  "NW facing plane, looking S")
		assertFalse (nwPlane.IsFacing (swLookVector), "NW facing plane, looking SW")		
		assertFalse (nwPlane.IsFacing (wLookVector),  "NW facing plane, looking W")
		assertFalse (nwPlane.IsFacing (nwLookVector), "NW facing plane, looking NW")			
	End Method		
	
End Type
