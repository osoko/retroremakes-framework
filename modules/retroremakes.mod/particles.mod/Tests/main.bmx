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

SuperStrict

Framework bah.maxunit
Import retroremakes.particles

Include "valueTest.bmx"
Include "floatValueTest.bmx"
Include "colorValueTest.bmx"
Include "particleActorTest.bmx"
Include "particleTest.bmx"
Include "managerTest.bmx"

' Mocks used by the tests
Include "Mocks/TValueMOCK.bmx"
Include "Mocks/TParticleActorMOCK.bmx"

New TTestSuite.run()
