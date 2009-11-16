rem
	bbdoc: Get the greatest common divisor of two integers
endrem
Function rrGreatestCommonDivisor:Int(a:Int, b:Int)
	If b = 0
		Return a
	End If
	Return rrGreatestCommonDivisor(b, a Mod b)
End Function