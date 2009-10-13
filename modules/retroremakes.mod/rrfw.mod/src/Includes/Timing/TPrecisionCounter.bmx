rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Private

Global _PrecisionCounter:TPrecisionCounter = TPrecisionCounter.Create()

Public

?Win32
Extern "Win32"
	Function QueryPerformanceCounter( lpPerformanceCount:Long Var )
	Function QueryPerformanceFrequency( lpFrequency:Long Var )
EndExtern
?

Type TPrecisionCounter
	Field precision:Int
		
	Function Create:TPrecisionCounter() 
	
		' TODO: Need to find out how to utilise precision counters on MacOS/Linux,
		' for now they just use the normal BlitzMax Millisecs() command.
		
		Local timer:TPrecisionCounter
		?Win32
			Local frequency:Long
	
			If QueryPerformanceFrequency(frequency) 
				timer:TPrecisionCounter = New TPrecisionCounterWin32
				timer.precision = True
			Else
		?
				timer:TPrecisionCounter = New TNormalPrecisionCounter
				timer.precision = False
		?Win32
			EndIf
		?
		Return timer
	EndFunction
	
	Method MilliSecs:Double() Abstract

	Method Ticks:Long() Abstract
	
	Method IsPrecision:Int() 
		Return precision
	End Method
EndType

?Win32
Type TPrecisionCounterWin32 Extends TPrecisionCounter
	Field frequency:Double
	Field _ticks:Long

	Method MilliSecs:Double() 
		Local ticks:Long

		If QueryPerformanceCounter( ticks )
			Return (Double(ticks) * 1000.0:Double) / frequency
		Else
			Return Null
		EndIf
	EndMethod

	Method Ticks:Long() 
		If QueryPerformanceCounter(_ticks) 
			Return _ticks
		Else
			Return Null
		EndIf
	End Method
	
	Method New() 
		Local freq:Long
		QueryPerformanceFrequency(freq) 
		frequency = Double(freq) 
	End Method
EndType
?

Type TNormalPrecisionCounter Extends TPrecisionCounter
	Method MilliSecs:Double() 
		Return Double(brl.blitz.MilliSecs()) 
	EndMethod
	
	Method Ticks:Long() 
		Return Null
	End Method
EndType

Function rrPrecisionCounterAvailable:Int()
	Return _PrecisionCounter.IsPrecision()
End Function

Function rrMillisecs:Double()
	Return _PrecisionCounter.MilliSecs()
End Function

Function rrTicks:Long()
	Return _PrecisionCounter.Ticks()
End Function