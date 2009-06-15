Function rrCapValueToByte:Int(val:Int)
	If val < 0 Then val = 0
	If val > 255 Then val = 255
	Return val
End Function
