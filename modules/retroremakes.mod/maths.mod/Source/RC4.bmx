rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.

' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: Encrypt or Decrypt a string using an RC4 cypher
	returns: Either an Encrypted or Decrypted String
endrem
Function RC4:String(inputString:String, key:String)
	Local s:Int[ 512 + Ceil( inputString.Length * .55 ) ]
	Local i:Int
	Local j:Int
	Local t:Int
	Local x:Int
	Local outputBuffer:Short Ptr = Short Ptr(Varptr s[512])
 
    j = 0
    For i = 0 To 255
        s[i] = i
        If j > ( Key.length - 1 )
            j = 0
        EndIf
        s[256+i] = key[j] & $ff
        j :+ 1
    Next
    
    j = 0
    For i = 0 To 255
        j = ( j + s[i] + s[256+i] ) & $ff
        t = s[i]
        s[i] = s[j]
        s[j] = t
    Next
    
    i = 0
    j = 0
    For x:Int = 0 To inputString.Length-1
        i = ( i + 1 ) & $ff
        j = ( j + s[i] ) & $ff
        t = s[i]
        s[i] = s[j]
        s[j] = t
        t = ( s[i] + s[j] ) & $ff
        outputBuffer[x] = ( inputString[x] ~ s[t] )
    Next

    Return String.FromShorts( outputBuffer, inputString.Length )
End Function
