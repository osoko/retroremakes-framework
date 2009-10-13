rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

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
