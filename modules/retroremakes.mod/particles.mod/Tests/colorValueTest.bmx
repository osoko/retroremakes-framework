Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type colorValueTest Extends TTest

	Field c:TColorValue
	
	Method setup() {before}
		c = New TColorValue
	End Method
	
	Method cleanup() {after}
		c = Null
	End Method
	
	'can we create a tcolorvalue?
	Method testCreateColor() {test}
		assertNotNull(c)
	End Method
	
	'can we set and get the starting color values?  
	Method testSetStartColor() {test}
		c.SetStartColorValue(200, 150, 210)
		
		Local clr:Trgb = c.GetStartColor()
		
		assertEqualsF(200, clr._r)
		assertEqualsF(150, clr._g)
		assertEqualsF(210, clr._b)
	End Method
	

	'can we set and get the ending color values? 
	Method testSetEndColor() {test}
		c.SetEndColorValue(200, 200, 200)
		
		Local clr:Trgb = c.GetEndColor()
		
		assertEqualsF(200, clr._r)
		assertEqualsF(200, clr._g)
		assertEqualsF(200, clr._b)
	End Method

	'can we reset the current color
	Method testResetValue() {test}
		c.SetStartColorValue(200, 200, 201)
		c.ResetValue()

		Local clr:Trgb = c.GetCurrentColor()
		
		assertEqualsF(200, clr._r)
		assertEqualsF(200, clr._g)
		assertEqualsF(201, clr._b)
	End Method
	
	'can we use a tcolorvalue?
	Method testUseColor() {test}
		c.SetStartColorValue(42, 44, 46)
		c.ResetValue()

		Graphics 800, 600
		c.Use()
		
		Local r:Int, g:Int, b:Int
		brl.max2d.GetColor(r, g, b)
		
		assertEqualsI(42, r)
		assertEqualsI(44, g)
		assertEqualsI(46, b)
		
		EndGraphics()
		
	End Method
	
	'can we reverse the change range?
	Method testReverseChange() {test}
		c.SetStartColorValue(200, 100, 50)
		c.SetEndColorValue(250, 50, 150)
		
		c.ReverseChange()
		
		Local clr:Trgb
		clr = c.GetStartColor()
		assertEqualsF(250, clr._r)
		assertEqualsF(50, clr._g)
		assertEqualsF(150, clr._b)

		clr = c.GetEndColor()
		assertEqualsF(200, clr._r)
		assertEqualsF(100, clr._g)
		assertEqualsF(50, clr._b)
		
	End Method
	
	'can we clone a color?
	Method testClone() {test}
	
		c.SetStartColorValue(200, 100, 50)
		c.SetEndColorValue(250, 50, 150)
		c.SetCurrentColorValue(100, 100, 100)
		c.SetActive(True)
		c.SetMode(MODE_RUNNING)
		c.SetBehaviour(BEHAVIOUR_REPEAT)
		c.SetChangeAmount(0.5)
		c.SetCountdown(50)
		
		Local c2:TColorValue = c.Clone()
		assertNotNull(c2)
		
		Local clr:Trgb
		clr = c.GetStartColor()
		assertEqualsF(200, clr._r)
		assertEqualsF(100, clr._g)
		assertEqualsF(50, clr._b)
		
		clr = c.GetEndColor()
		assertEqualsF(250, clr._r)
		assertEqualsF(50, clr._g)
		assertEqualsF(150, clr._b)
		
		clr = c.GetCurrentColor()
		assertEqualsF(100, clr._r)
		assertEqualsF(100, clr._g)
		assertEqualsF(100, clr._b)
		
		assertEqualsI(True, c.GetActive())
		assertEqualsI(MODE_RUNNING, c.GetMode())
		assertEqualsI(BEHAVIOUR_REPEAT, c.Getbehaviour())
		assertEqualsF(0.5, c.GetChangeAmount())
		assertEqualsI(50, c.GetCountdown())
		
	End Method

End Type