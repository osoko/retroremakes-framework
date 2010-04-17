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

Type floatValueTest Extends TTest

	Field f:TFloatValue
	
	Method Setup() {before}
		f = New TFloatValue
	End Method
	
	Method cleanup() {after}
		f = Null
	End Method	
	
	'can we create a float value
	Method testCreateFloat() {test}
		assertNotNull(f)
	End Method

	'can we set the start value
	Method testSetStartValue() {test}
		f.SetStartValue(2.0)
		assertEqualsF(2.0, f.GetStartValue())
	End Method
	
	'can we set the end value
	Method testSetEndValue() {test}
		f.SetEndValue(10.0)
		assertEqualsF(10.0, f.GetEndValue())
	End Method
	
	'can we set the change amount
	Method testSetChangeAmount() {test}
		f.SetChangeAmount(0.5)
		assertEqualsF(0.5, f.GetChangeAmount())
	End Method
	
	'does update() advance the values correctly?
	Method testUpdate() {test}
	
		f.SetStartValue(1.0)
		f.SetEndValue(2.0)
		f.SetChangeAmount(0.2)
		f.SetActive(True)
		f.ResetValue()
		f.SetMode(MODE_RUNNING)

		f.Update()
		assertEqualsF(1.2, f.GetCurrentValue())
	End Method
	
	'can we clone a tfloatvalue?
	Method testClone() {test}

		f.SetStartValue(1.0)
		f.SetEndValue(2.0)
		f.SetChangeAmount(0.2)
		f.SetActive(True)
		f.ResetValue()
		f.SetMode(MODE_RUNNING)
	
		Local f2:TFloatValue = f.Clone()
		assertNotNull(f2)
		
		'test the settings of cloned tfloatvalue		
		assertEqualsI(f.GetBehaviour(), f2.GetBehaviour(), "behaviour")
		assertEqualsF(f.GetStartValue(), f2.GetStartValue(), 0, "start value")
		assertEqualsF(f.GetEndValue(), f2.GetEndValue(), 0, "end value")
		assertEqualsI(f.GetActive(), f2.GetActive(), "active")
		assertEqualsI(f.GetMode(), f2.GetMode(), "mode")
	
	End Method
	
	'can we correctly scale the change range and changeamount?
	Method testScaleRange() {test}
		f.SetStartValue(1.0)
		f.SetEndValue(2.0)
		f.SetChangeAmount(0.2)
		
		f.ScaleRange(2.0)
		assertEqualsF(2.0, f.GetStartValue())
		assertEqualsF(4.0, f.GetEndValue())
		assertEqualsF(0.4, f.GetChangeAmount())

	End Method
	
	'can we move the change range?
	Method testMoveRange() {test}
		f.SetStartValue(1.0)
		f.SetEndValue(2.0)
		
		f.MoveRange(5.0)
		assertEqualsF(6.0, f.GetStartValue())
		assertEqualsF(7.0, f.GetEndValue())
		
	End Method
	
	'can we fix the float at a value?
	Method testFix() {test}
		f.SetCurrentValue(1.0)
		f.Fix(3.0)
		
		assertFalse(f.GetActive())
		assertEqualsF(3.0, f.GetCurrentValue())
		
	End Method
	
	'can we load settings from string?
	
	
	
End Type
