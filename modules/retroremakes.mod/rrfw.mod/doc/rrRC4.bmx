' The key we're going to use to encrypt and decrypt the data, this can be any string
Local key:String = "This is just a random string to use as an encryption key"

' First we encrypt a string
Local encrypted:String = rrRC4("I wonder what this looks like encrypted", key)
Print "Encrypted: " + encrypted

' We can decrypt it by running it through the rrRC4 function again using the same key
Local decrypted:String = rrRC4(encrypted, key)
Print "Decrypted: " + decrypted

' If you use the wrong key then you can't decrypt the message
Print "Wrong Key: " + rrRC4(encrypted, "This is definitely the wrong encryption key!")