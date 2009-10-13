rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Function rrSplitString:TList(inString:String, Delim:String)
	Local tempList:TList = New TList
'	Local currentChar:String = ""
	Local count:Int = 0
	Local TokenStart:Int = 0
	
	If Len(Delim)<>1 Then Return Null
	
	inString = Trim(inString)
	
	For count = 0 Until Len(inString)
		If inString[count..count+1] = delim Then
			tempList.AddLast(inString[TokenStart..Count])
			TokenStart = count + 1
		End If
	Next
	tempList.AddLast(inString[TokenStart..Count])	
	Return tempList
End Function