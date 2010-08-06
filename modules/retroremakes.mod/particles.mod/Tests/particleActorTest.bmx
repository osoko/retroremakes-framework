

Type particleActorTest Extends TTest

	Field p:TParticleActorMOCK
	
	Method setup() {before}
		p = New TParticleActorMOCK
	End Method
	
	Method cleanup() {after}
		p = Null
	End Method
	
	' Can we create a particleActor?
	Method testCreateParticleActor() {test}
		assertNotNull(p)
	End Method
	
	'can we set friction?
	Method testFriction() {test}
		p.SetFriction(0.2)
		assertEqualsF(0.2, p.GetFriction())
	End Method
	
	'can we set life?
	Method testLife() {test}
		p.SetLife(100)
		assertEqualsI(100, p.GetLife())
	End Method
	
	'can we update life?
	Method testUpdateLife() {test}
		p.SetLife(20)
		p.UpdateLife()
		assertEqualsI(19, p.GetLife())
	End Method
	
	'does actor die when life has run out?
	Method testDieWhenLifeRunsOut() {test}
		p.SetLife(1)
		Local result:Int = p.UpdateLife()
		assertEqualsI(False, result)
		
	End Method
	
	'can we set the id?
	Method testSetID() {test}
		Local id:Int = 1
		p.SetID(id)
		assertEqualsI(id, p.GetID())
	End Method
	
	'can we set the gamename?
	Method testSetGameName() {test}
		Local name:String = "gamename"
		p.SetGameName(name)
		assertEquals(name, p.GetGameName())
	End Method
	
	'can we set the editor name?
	Method testSetEditorName() {test}
		Local name:String = "editor name"
		p.SetEditorName(name)
		assertEquals(name, p.GetEditorName())
	End Method
	
	'can we set description?
	Method testSetDescription() {test}
		Local name:String = "desc"
		p.SetDescription(name)
		assertEquals(name, p.GetDescription())
	End Method
	
	' Can we set and add to the acceleration of tparticleactor
	Method testSetAcceleration() {test}
	
		Local vec:TVector2D = TVector2D.Create(1, 5)
		p.SetAcceleration(vec)
		Local result:Tvector2D = p.GetAcceleration()
		
		assertEqualsF(vec.x, result.x)
		assertEqualsF(vec.y, result.y)
		
		p.AddAcceleration(vec)
		result = p.GetAcceleration()
		
		assertEqualsF(vec.x * 2, result.x)
		assertEqualsF(vec.y * 2, result.y)		
		
	End Method
	
	' Can we apply acceleration correctly to the tparticleactor
	Method testApplyPhysicsAcceleration() {test}

		Local vec:Tvector2D = TVector2D.Create(2.0, 1.0)
		p.SetAcceleration(vec)
		
		'use applyphysics() in MOCK
		p.ApplyPhysics()
		
		'120 is the fixed timestep update frequency we are using in the mock
		Local result:Tvector2D = p.GetVelocity()
		assertEqualsF(2.0 / 120, result.x)
		assertEqualsF(1.0 / 120, result.y)
			
	End Method
	
	
	'can we apply friction
	Method testApplyPhysicsFriction() {test}

		p.SetFriction(0.1)
		
		'HACK: force some velocity
		p._velocity.x = 1.0
		p._velocity.y = 2.0
		
		'use applyphysics() in MOCK
		p.ApplyPhysics()
		
		Local result:Tvector2D = p.GetVelocity()
		assertEqualsF(1.0 * 0.9, result.x)
		assertEqualsF(2.0 * 0.9, result.y)
		
	End Method
	
	' can we add a child, and will it know its parent?
	Method testAddChild() {test}
		Local child1:TParticleActorMOCK = New TParticleActorMOCK
		p.AddChild(child1)
		
		Local childList:TList = p.GetChildren()
		assertTrue(childList.Contains(child1))
		assertSame(p, child1.GetParent())
	End Method
	
	' can we remove a child, and will that child forget its parent?
	Method testRemoveChild() {test}
		Local child1:TParticleActorMOCK = New TParticleActorMOCK
		p.AddChild(child1)
		
		Local childList:TList = p.GetChildren()
		assertTrue(childList.Contains(child1))
		assertSame(p, child1.GetParent())

		p.RemoveChild(child1)
		
		assertFalse(childList.Contains(child1))
		assertNull(child1.GetParent())
	End Method
	
	' can we remove all children
	Method testRemoveAllChildren() {test}
		Local child1:TParticleActorMOCK = New TParticleActorMOCK
		Local child2:TParticleActorMOCK = New TParticleActorMOCK
		p.AddChild(child1)
		p.AddChild(child2)
		
		Local childList:TList = p.GetChildren()
		assertTrue(childList.Contains(child1))
		assertTrue(childList.Contains(child2))
		
		p.RemoveAllChildren()
		assertFalse(childList.Contains(child1))
		assertFalse(childList.Contains(child2))
		
		assertNull(child1.GetParent())
		assertNull(child2.GetParent())
		
	End Method
	
	' can we set a parent
	Method testSetParent() {test}
		Local parent:TParticleActorMOCK = New TParticleActorMOCK
		p.SetParent(parent)
		
		assertEquals(parent, p.GetParent())
	End Method
	
	'is new parent aware that it has a child?
	Method testGetChildren() {test}
		Local parent:TParticleActorMOCK = New TParticleActorMOCK
		p.SetParent(parent)
		
		assertEquals(parent, p.GetParent())
		
		Local childList:TList = parent.GetChildren()
		assertTrue(childList.Contains(p))
	End Method

	'future tests:
	' Can we add the actor to a layer
	' Can we remove the actor from a layer
	' Can we set the position of the actor
	' Can we read the position of the actor
	' Can we rotate the actor
	' Can we rotate the actor around a point
	
End Type



