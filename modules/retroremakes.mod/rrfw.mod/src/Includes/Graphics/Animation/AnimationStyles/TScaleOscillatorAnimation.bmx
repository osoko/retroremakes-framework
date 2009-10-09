Rem
	bbdoc: Sprite animation style for applying scale oscillations.
End Rem
Type TScaleOscillatorAnimation Extends TAnimation

	Const DEFAULT_SCALEGEN_OFFSET:Float = 0.0
	
	Field scaleGen:TScaleGen
	Field offset:Float
	
	Method New()
		Self.scaleGen = New TScaleGen
		Self.offset = DEFAULT_SCALEGEN_OFFSET
	End Method
	
	Method SetScaleGen(scaleGen:TScaleGen)
		Self.scaleGen = scaleGen
	End Method
	
	Method SetOffset(offset:Float)
		Self.offset = offset
	End Method
	
	Method Update:Int(actor:TActor)
		rrUnpackScaler(rrGenOscillatorScale(scaleGen, offset), actor.xScale, actor.yScale)
		Return Finished()
	End Method

End Type
