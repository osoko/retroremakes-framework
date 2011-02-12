Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type valueTest Extends TTest

	'use a mock because tvalue is abstract and has abstract methods
	Field v:TValueMOCK
	
	Method setup() {before}
		v = New TValueMOCK
	End Method
	
	Method cleanup() {after}
		v = Null
	End Method
	
	' Can we create a TValue?
	Method testCreateValue() {test}
		assertNotNull(v)
	End Method
	
	' Can we set the behaviour?
	Method testSetBehaviour() {test}
		v.SetBehaviour(BEHAVIOUR_ONCE)
		assertEqualsI(BEHAVIOUR_ONCE, v.GetBehaviour())
	End Method
	
	'can we enable the value
	Method testSetActive() {test}
		v.SetActive(True)
		assertEqualsI(True, v.GetActive())
	End Method
	
	'can we set the mode of the value
	Method testSetMode() {test}
		v.SetMode(MODE_RUNNING)
		assertEqualsI(MODE_RUNNING, v.GetMode())
	End Method
	
	'can we alter the amount by which the value changes?
	Method testSetChangeAmount() {test}
 		v.SetChangeAmount(2.0)
		assertEqualsF(2.0, v.GetChangeAmount())
	End Method
	
	'can we set a pre-change countdown?
	Method testSetCountdown() {test}
		v.SetCountdown(10)
		assertEqualsI(10, v.GetCountdown())
	End Method

End Type
