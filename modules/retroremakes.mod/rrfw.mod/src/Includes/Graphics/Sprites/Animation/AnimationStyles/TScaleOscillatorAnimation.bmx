'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TScaleOscillatorAnimation Extends TSpriteAnimation

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
	
	Method Update:Int(sprite:TSprite)
		rrUnpackScaler(rrGenOscillatorScale(scaleGen, offset), sprite.xScale_, sprite.yScale_)
		Return Finished()
	End Method

End Type
