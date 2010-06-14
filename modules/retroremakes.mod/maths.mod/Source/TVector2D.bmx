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

Type TVector2D

	Field x:Float
	Field y:Float
	
	Function Create:TVector2D(x_in:Float,y_in:Float)
		Local v:TVector2D = New TVector2D
		v.x = x_in
		v.y = y_in
		Return v
	End Function
	
	Method Copy:TVector2D()
		Return Create(x,y)
	End Method

	Method Swap(v:TVector2D)
		Local tmp:Float = x
		x = v.x
		v.x = tmp
		
		tmp = y
		y = v.y
		v.y = tmp
	End Method
	
	Method Set(x_in:Float, y_in:Float)
		x = x_in
		y = y_in
	End Method

	Method SetV(v:TVector2D)
		x = v.x
		y = v.y
	End Method
	
	Method AddV(v:TVector2D)
		x :+ v.x
		y :+ v.y
	End Method
	
	Method SubV(v:TVector2D)
		x :- v.x
		y :- v.y
	End Method
	
	Method AddF(fx:Float, fy:Float)
		x :+ fx
		y :+ fy
	End Method
	
	Method SubF(fx:Float, fy:Float)
		x :- fx
		y :- fy
	End Method
	
	Method MulF(f:Float)
		x :* f
		y :* f
	End Method

	Method DivF(f:Float)
		Assert(f <> 0.0:Float)
		x :/ f
		y :/ f
	End Method

	Method Normalise()
		DivF(length())
	End Method
	
	Method Length:Float()
		Return Sqr(x*x + y*y)
	End Method
	
	Method Length2:Float()
		Return (x*x + y*y)
	End Method

	Method Dot:Float(v:TVector2D)
		Return (x*v.x + y*v.y)
	EndMethod
	
	Method Distance:Float(v:TVector2D)
		Local dx:Float = x - v.x
		Local dy:Float = y - v.y
		Return Sqr(dx*dx + dy*dy)
	EndMethod

	Method Compare:Int(o:Object)
		Const approx:Float=0.0001:Float
		
		Local v:TVector2D = TVector2D(o)
		If((Abs(v.x-x)<approx) And (Abs(v.y-y)<approx)) Then Return 0
		
		Return Int(v.length2() - length2())
	EndMethod

	Method Rotate(theta:Float)
		Local cs:Float = Cos(theta)
		Local sn:Float = Sin(theta)
		Local qx:Float=  x * Cs + y * Sn
		Local qy:Float= -x * Sn + y * Cs
		x = qx
		y = qy
	EndMethod

	Method RotateAbout(v:TVector2D, theta:Float)
		Local cs:Float = Cos(theta)
		Local sn:Float = Sin(theta)
		x = x - v.x
		y = y - v.y
		Local qx:Float =  x * Cs + y * Sn
		Local qy:Float = -x * Sn + y * Cs
		x = qx + v.x
		y = qy + v.y
	EndMethod

	Method GetRotation:Float()
		Return ATan2( y,x )
	EndMethod
	
End Type

Function V2Add:TVector2D(v1:TVector2D, v2:TVector2D)
	Return TVector2D.Create(v1.x+v2.x, v1.y+v2.y)
End Function

Function V2Sub:TVector2D(v1:TVector2D, v2:TVector2D)
	Return TVector2D.Create(v1.x-v2.x, v1.y-v2.y)
End Function

Function V2Mul:TVector2D(v:TVector2D, f:Float)
	Return TVector2D.Create(v.x*f, v.y*f)
End Function

Function V2Div:TVector2D(v:TVector2D, f:Float)
	Assert(f<>0.0:Float)
	Return TVector2D.Create(v.x/f, v.y/f)
End Function
