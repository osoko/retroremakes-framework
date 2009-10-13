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
	bbdoc: Base class for animations
End Rem
Type TAnimation

	Field callBackFunction()
	Field isFinished:Int
	
	Method Finished:Int()
		If isFinished And callBackFunction
			callBackFunction()
		EndIf
		Return isFinished
	End Method
	
	Method Initialise()
		Reset()
	End Method

	Method New()
		Self.isFinished = False
	End Method
	
	Method Remove()
	End Method
	
	Method Reset()
		Self.isFinished = False
	End Method
	
	Method SetCallBack(func())
		callBackFunction = func
	End Method
	
	Method Update:Int(sprite:TActor) Abstract
	
End Type
