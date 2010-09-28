
Type managerTest Extends TTest

	Field m:TParticleManager
		
	Method setup() {before}
		m = TParticleManager.GetInstance()
	End Method
	
	' Can we create a manager?
	Method testGetInstance() {test}
		assertNotNull(m)
	End Method

	' can we create only one manager? we should get an exception.
	Method testNew() {test}
		Try
			Local m2:TParticleManager = New TParticleManager
		Catch result:String
			assertEquals(result, "Cannot create multiple instances of this Singleton Type")
		End Try

	End Method
	
	' Can we load the library configuration?
	Method testLoadConfiguration() {test}
		
	End Method
	
	'can we retrieve the particle library from the manager?
	Method testGetParticleLibrary() {test}
		Local result:TParticleLibrary
		result = m.GetParticleLibrary()
		assertNotNull(result)
	End Method
	
	'can we retrieve the manager name?
	Method testToString() {test}
		Local result:String = m.ToString()
		assertEquals(result, "Particle Manager")
	End Method
	
	' Can we create an emitter?
	Method testCreateEmitter() {test}
		
	End Method
	
	' Can we create an effect?
	Method testCreateEffect() {test}
		
	End Method
	
	'future tests:
	' Do we get an error if the requested effect cannot be found in the library?
	' Do we get an error if the requested emitter cannot be found in the library?

End Type
