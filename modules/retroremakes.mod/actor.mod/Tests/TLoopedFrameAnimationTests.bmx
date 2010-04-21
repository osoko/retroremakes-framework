
Type TLoopedFrameAnimationTests Extends TTest

	Field _animation:TLoopedFrameAnimation
	
	Method _setup() {before}
		_animation = New TLoopedFrameAnimation
	End Method
	
	Method _teardown() {after}
		_animation = Null
	End Method
	
	' Issue #23: TLoopedFrameAnimation performs loop even if loop count set to zero
	' http://code.google.com/p/retroremakes-framework/issues/detail?id=23
	Method LoopCounterMustNotBeSetToZero() {test}
		Local succeeded:Int = True
		Try
			_animation.SetLoopCount(0)
		Catch exception:Object
			succeeded = False
		End Try
		assertFalse(succeeded, "Able to set loop count to zero.")
	End Method
	
End Type