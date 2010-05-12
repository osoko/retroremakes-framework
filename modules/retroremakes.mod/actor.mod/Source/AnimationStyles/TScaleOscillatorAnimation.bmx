rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
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

	' Default offset to use for the scale generator
	Const DEFAULT_SCALEGEN_OFFSET:Float = 0.0
	
	' The offest to use when running the scale generator
	Field _offset:Float
	
	' The scale generator to use for this animation
	Field _scaleGen:TScaleGen
	
	
	
	Rem
		bbdoc:Returns a copy of the animation
	End Rem
	Method Copy:TAnimation()
		Local animation:TScaleOscillatorAnimation = New TScaleOscillatorAnimation
		animation._offset = _offset
		animation._scaleGen = _scaleGen
		animation.Reset()
		Return animation
	End Method

	
	
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		_scaleGen = New TScaleGen
		_offset = DEFAULT_SCALEGEN_OFFSET
	End Method

	
	
	rem
		bbdoc: Set the offset to use with the scale generator
	endrem
	Method SetOffset(value:Float)
		_offset = value
	End Method
		
	
	
	rem
		bbdoc: Set the scale generator to use
	endrem	
	Method SetScaleGen(scaleGen:TScaleGen)
		_scaleGen = scaleGen
	End Method
	

	
	rem
		bbdoc: Update the animation
	endrem
	Method Update:Int(actor:TActor)
		rrUnpackScaler(rrGenOscillatorScale(_scaleGen, _offset), actor._xScale, actor._yScale)
		Return IsFinished()
	End Method

End Type
