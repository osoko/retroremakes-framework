rem
	bbdoc: Type description
end rem
Type TLayerManagerTests Extends TTest
	
	Method Before() {before}
		TLayerManager.GetInstance().CreateLayer(10, "default")
	End Method

	Method After() {after}

	End Method
	
	Method CanAddLayer() {test}
		Local layer:TRenderLayerMock = New TRenderLayerMock
		layer.SetName("mockLayer")
		layer.SetId(255)
		assertTrue(TLayerManager.GetInstance().AddLayer(layer))
		assertNotNull(TLayerManager.GetInstance().GetLayerById(255))
	End Method
	
	Method CanCreateLayer() {test}
		assertTrue(TLayerManager.GetInstance().CreateLayer(20, "anotherOne"))
		assertNotNull(TLayerManager.GetInstance().GetLayerById(20))
		assertNotNull(TLayerManager.GetInstance().GetLayerByName("anotherOne"))
	End Method
	
	Method CanGetLayerById() {test}
		Local layer:TRenderLayer = TLayerManager.GetInstance().GetLayerById(10)
		assertNotNull(layer)
		assertEquals("default", layer.GetName())
		assertEqualsI(10, layer.GetId())
	End Method
	
	Method CanGetLayerByName() {test}
		Local layer:TRenderLayer = TLayerManager.GetInstance().GetLayerByName("default")
		assertNotNull(layer)
		assertEquals("default", layer.GetName())
		assertEqualsI(10, layer.GetId())
	End Method
	
	Method CanDisableLayerById() {test}
		assertTrue(TLayerManager.GetInstance().CreateLayer(30, "anotherTwo"))
		assertFalse(TLayerManager.GetInstance().GetLayerById(30).IsDisabled())
		assertTrue(TLayerManager.GetInstance().DisableLayerById(30))
		assertTrue(TLayerManager.GetInstance().GetLayerById(30).IsDisabled())
	End Method
	
	Method CanDisableLayerByName() {test}
		assertTrue(TLayerManager.GetInstance().CreateLayer(40, "anotherThree"))
		assertFalse(TLayerManager.GetInstance().GetLayerById(40).IsDisabled())
		assertTrue(TLayerManager.GetInstance().DisableLayerByName("anotherThree"))
		assertTrue(TLayerManager.GetInstance().GetLayerById(40).IsDisabled())
	End Method
	
	Method CanEnableLayerById() {test}
		assertTrue(TLayerManager.GetInstance().CreateLayer(50, "anotherFour"))
		assertFalse(TLayerManager.GetInstance().GetLayerById(50).IsDisabled())
		assertTrue(TLayerManager.GetInstance().DisableLayerByName("anotherFour"))
		assertTrue(TLayerManager.GetInstance().GetLayerById(50).IsDisabled())
		assertTrue(TLayerManager.GetInstance().EnableLayerByName("anotherFour"))
		assertFalse(TLayerManager.GetInstance().GetLayerById(50).IsDisabled())		
	End Method
	
	Method CanEnableLayerByName() {test}
		assertTrue(TLayerManager.GetInstance().CreateLayer(60, "anotherFive"))
		assertFalse(TLayerManager.GetInstance().GetLayerById(60).IsDisabled())
		assertTrue(TLayerManager.GetInstance().DisableLayerById(60))
		assertTrue(TLayerManager.GetInstance().GetLayerById(60).IsDisabled())
		assertTrue(TLayerManager.GetInstance().EnableLayerById(60))
		assertFalse(TLayerManager.GetInstance().GetLayerById(50).IsDisabled())			
	End Method
	
End Type
