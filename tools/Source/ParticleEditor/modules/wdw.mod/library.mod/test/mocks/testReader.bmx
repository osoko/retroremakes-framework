

rem
bbdoc: Reads line, determines object types, calls New() method of object and passes the stream to this object
       After this, the object is added to the library.
endrem
Type TTestReader Extends TLibraryReader

	Method Read:Int(stream:TStream)
		While Not Eof(stream)
			Local line:String = ReadLine(stream)
			line.Trim()
			line.ToLower()
			
			If line = "" Then Continue
			Select line
				Case "[testobject]"
				
					Local o:testobject = New testObject
					Local id:Int = o.ReadPropertiesFromStream(stream)
					
					library.AddObject(o, id)
					library.DetermineNextID(id)
					
				Default
					Return False
					'Throw "" + line + " is not a recognized object!"
			End Select
		Wend
		Return True
	End Method
		
End Type

