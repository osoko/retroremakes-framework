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

		
	Function Create :TVector2D (x :Float = 0.0, y :Float = 0.0)
		Local v :TVector2D = New TVector2D
		v.x = x
		v.y = y
		Return v
	End Function

	
	Method AddF :TVector2D (x :Float, y :Float)
		Self.x :+ x
		Self.y :+ y
		Return Self
	End Method
	
		
	Method AddV :TVector2D (v :TVector2D)
		x :+ v.x
		y :+ v.y
		Return Self
	End Method
	
		
	Method Compare :Int (o :Object)
		Const EPSILON :Float = 0.00001 :Float
		
		Local v :TVector2D = TVector2D (o)
		If ((Abs (v.x - x) < EPSILON) And (Abs (v.y - y) < EPSILON)) Then Return 0
		
		Return Int (v.length2() - length2())
	End Method
	
			
	Method Copy :TVector2D ()
		Return Create (Self.x, Self.y)
	End Method

	
	Method Distance :Float (v :TVector2D)
		Local dx :Float = x - v.x
		Local dy :Float = y - v.y
		
		Return Sqr (dx * dx + dy * dy)
	End Method
	
			
	Method DivF :TVector2D (f :Float)
		Assert (f <> 0.0 :Float)
		x :/ f
		y :/ f
		Return Self
	End Method
	

	Method Dot :Float (v :TVector2D)
		Return (x * v.x + y * v.y)
	End Method
	
	
	Method GetRotation :Float ()
		Return ATan2 (y, x)
	EndMethod
	
		
	Method Length :Float ()
		Return Sqr (x * x + y * y)
	End Method
	
		
	Method Length2 :Float ()
		Return (x * x + y * y)
	End Method
	
	
	Method MulF :TVector2D (f :Float)
		x :* f
		y :* f
		Return Self
	End Method
	
	
	Method New()
		x = 0.0
		y = 0.0	
	End Method
	
	
	Method Normalise :TVector2D ()
		DivF (length())
		Return Self
	End Method
	
	
	Method Reflect :TVector2D (normal :TVector2D)
		Local dotProduct:Float = Dot (normal)
		
		x :+ -2 * normal.x * dotProduct
		y :+ -2 * normal.y * dotProduct
		
		Return Self
	End Method
	
	
	Method Rotate :TVector2D (theta :Float)
		Local cs :Float = Cos (theta)
		Local sn :Float = Sin (theta)
		
		Local qx :Float=  x * Cs + y * Sn
		Local qy :Float= -x * Sn + y * Cs
		
		x = qx
		y = qy
		
		Return Self
	EndMethod

	
	Method RotateAbout :TVector2D (v :TVector2D, theta :Float)
		Local cs :Float = Cos (theta)
		Local sn :Float = Sin (theta)
		
		x = x - v.x
		y = y - v.y
		
		Local qx :Float =  x * Cs + y * Sn
		Local qy :Float = -x * Sn + y * Cs
		
		x = qx + v.x
		y = qy + v.y
		
		Return Self
	EndMethod
	
				
	Method Set :TVector2D (x :Float, y :Float)
		DebugLog "TVector2D.Set() method is deprecated and may be removed in future versions"
		Return SetF (x, y)
	End Method
	
	
	Method SetF :TVector2D (x :Float, y :Float)
		Self.x = x
		Self.y = y
		Return Self
	End Method
	

	Method SetV :TVector2D (v :TVector2D)
		x = v.x
		y = v.y
		Return Self
	End Method
	

	Method SubF :TVector2D (x :Float, y :Float)
		Self.x :- x
		Self.y :- y
		Return Self
	End Method
	
	
	Method SubV :TVector2D (v :TVector2D)
		x :- v.x
		y :- v.y
		Return Self
	End Method
	
			
	Method Swap :TVector2D (v :TVector2D)
		Local tmp :Float
		
		tmp = x
		x   = v.x
		v.x = tmp
		
		tmp = y
		y   = v.y
		v.y = tmp
		
		Return Self
	End Method
	
End Type
