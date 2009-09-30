rem
bbdoc: Encrypt or Decrypt a string using an RC4 cypher
returns: Either an Encrypted or Decrypted String
about:
endrem
Function rrRC4:String(inp:String, key:String)
	Local s:Int[ 512 + Ceil( inp.Length * .55 ) ]
	Local i:Int
	Local j:Int
	Local t:Int
	Local x:Int
	Local outbuf:Short Ptr = Short Ptr( Varptr s[512] )
 
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
    For x:Int = 0 To inp.Length-1
        i = ( i + 1 ) & $ff
        j = ( j + s[i] ) & $ff
        t = s[i]
        s[i] = s[j]
        s[j] = t
        t = ( s[i] + s[j] ) & $ff
        outbuf[x] = ( inp[x] ~ s[t] )
    Next

    Return String.FromShorts( outbuf, inp.Length )
End Function