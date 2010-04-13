
Function CapValueToByte:Int(val:Int)
	If val < 0 Then val = 0
	If val > 255 Then val = 255
	Return val
End Function

rem
	bbdoc: Get the greatest common divisor of two integers
endrem
Function GreatestCommonDivisor:Int(a:Int, b:Int)
	If b = 0
		Return a
	End If
	Return GreatestCommonDivisor(b, a Mod b)
End Function