

Type particleActorTest Extends TTest

	Field p:TParticleActorMOCK
	
	Method setup() {before}
		p = New TParticleActorMOCK
	End Method
	
	' Can we create a particleActor?
	Method testCreateParticleActor() {test}
		assertNotNull(p)
	End Method
	
	' Does it contain the necessary objects?
	' Can we set the position of the actor
	' Can we read the position of the actor
	' Can we set the acceleration of the actor
	' Can we read the acceleration of the actor
	' Can we apply physics to the actor
	' Can we add the actor to a layer
	' Can we remove the actor from a layer
	' Can we rotate the actor
	' Can we read the rotation of the actor
	' Can we rotate the actor around a point

End Type



'mock object because TParticleActor is Abstract and contains an Abstract method.
Type TParticleActorMOCK Extends TParticleActor
	
	Method Render(tweening:Double, fixed:Int)
	End Method
	
End Type