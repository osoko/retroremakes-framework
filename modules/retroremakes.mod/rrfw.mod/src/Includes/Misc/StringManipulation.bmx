rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: Split a string into a TList of strings
	returns: TList
endrem
Function rrSplitString:TList(inString:String, delimiter:String)
	Return New TList.FromArray(inString.Split(delimiter))
End Function