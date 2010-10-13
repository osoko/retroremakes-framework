
Type TRenderLayerMock extends TRenderLayer
	
	Field _renderCalls:Int
	Field _updateCalls:Int

	Rem
		bbdoc:Calls the Render method of all actors on this layer
	End Rem
	Method Render(tweening:Double, fixed:Int)
		_renderCalls:+1
	End Method

	Rem
		bbdoc:Calls the Update() method of all actors in this layer
	End Rem
	Method Update()
		_updateCalls:+1
	End Method

End Type
