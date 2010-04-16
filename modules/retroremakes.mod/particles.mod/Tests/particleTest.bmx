

Type particleTest Extends TTest

	Field p:TParticle
	
	Method setup() {before}
		p = New TParticle
	End Method
	
	' Can we create a particle?
	Method testCreateParticle() {test}
		assertNotNull(p)
	End Method
	
	' Can we set the particle properties using a config string?
	Method testSetProperties() {test}
		Local result:Int = p.SetProperties("id=1,desc=Test Particle")
		assertTrue(result)
	End Method

End Type


