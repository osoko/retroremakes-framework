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
		f.Fix(3.0)
		
		assertFalse(f.GetActive())
		assertEqualsF(3.0, f.GetCurrentValue())
		
		f.Update()
		assertEqualsF(3.0, f.GetCurrentValue())
		
	End Method
		
	'does import throw exception when array header is not ok?
	Method testDoesImportThrowExceptionOnBadLabel() {test}
		Local array:String[7]
		array[0] = "float_baaaad"
		
		Try
			f.ImportSettings(array)
		Catch result:String
			assertEquals("Array not a float array!", result)
		End Try
		
	End Method

	'does import throw exception when array length is not ok?	
	Method testDoesImportThrowExceptionOnWrongLength() {test}
		Local array:String[18]
		array[0] = "float"
		
		Try
			f.ImportSettings(array)
		Catch result:String
			assertEquals("Float array not complete!", result)
		End Try
	End Method
	
	'can we import settings from array?
	Method testImportSettings() {test}
	
		Local array:String[7]
		array[0] = "float"
		array[1] = "1"
		array[2] = String(BEHAVIOUR_REPEAT)
		array[3] = "10"
		array[4] = "2.0"
		array[5] = "3.0"
		array[6] = "0.2"
		
		f.ImportSettings(array)
		
		assertEqualsI(True, f.GetActive())
		assertEqualsI(BEHAVIOUR_REPEAT, f.GetBehaviour())
		assertEqualsF(1.0, f.GetActive())
		assertEqualsI(10, f.GetCountDown())
		assertEqualsF(2.0, f.GetStartValue())
		assertEqualsF(3.0, f.GetEndValue())
		assertEqualsF(0.2, f.GetChangeAmount())
	
	End Method
	
	'can we export settings to array?
	Method testExportSettings() {test}
	
		Local array:String[7]
		array[0] = "float"
		array[1] = "1"
		array[2] = String(BEHAVIOUR_REPEAT)
		array[3] = "10"
		array[4] = "2.0"
		array[5] = "3.0"
		array[6] = "0.2"
		
		f.ImportSettings(array)
		Local array2:String[] = f.ExportSettings()
		
		assertEquals("float", array2[0])
		assertEquals("1", array2[1])
		assertEqualsI(BEHAVIOUR_REPEAT, Int(array2[2]))
		assertEqualsI(10, Int(array2[3]))
		assertEqualsF(2.0, Float(array2[4]))
		assertEqualsF(3.0, Float(array2[5]))
		assertEqualsF(0.2, Float(array2[6]))
	End Method	
	
	
End Type
