
Type testObject

	Field id:Int
	Field textValue:String
	Field integerValue:Int
	Field floatValue:Float
	
	
	Method New()
		id = 10
		textValue = "test object"
		integerValue = 20
		floatValue = 10.21
	End Method
	
	
	Method ReadPropertiesFromStream:Int(stream:TStream)
	
		Local value:String[]
		Local line:String
		
		line = ReadLine(stream).Trim()
		line.ToLower()
	
		While line <> "[end object]"
		
			value = line.Split("=")
			
			Select value[0]
				Case "id"
					id = Int(value[1])
				Case "name"
					textValue = value[1]
				Case "integer"
					integerValue = Int(value[1])
				Case "float"
					floatValue = Float(value[1])
				Default
					Return False
'					Throw "" + value[0] + " is not a recognized label"
			End Select
		
			line = ReadLine(stream).Trim()
			line.ToLower()
		Wend
		Return id
	End Method
	
	
	
	Method WritePropertiesToStream:Int(stream:TStream)
		WriteLine(stream, "[testobject]")
		WriteLine(stream, "id=" + id)
		WriteLine(stream, "name=" + textValue)
		WriteLine(stream, "integer=" + String(integerValue))
		WriteLine(stream, "float=" + String(floatValue))
		WriteLine(stream, "[end object]")
		Return True
	End Method

		
	Method GetText:String()
		Return textValue
	End Method
	
	
	Method GetInt:Int()
		Return integerValue
	End Method
	
	
	Method GetFloat:Float()
		Return floatValue
	End Method
	
	
	Method GetID:Int()
		Return id
	End Method
	
End Type