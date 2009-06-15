Type TResourceImageFont Extends TResource

	Field font:TImageFont

	Field size:Int
	Field flags:Int
	
	
	Method Free()
		font = Null
	End Method
	
	
	
	Method GetResource:TImageFont()
		Return font
	End Method
	
	
			
	Method Load(path:String, size:Int = 12, flags:Int = SMOOTHFONT)
		font = LoadImageFont(path, size, flags)
		Self.path = path
		Self.size = size
		Self.flags = flags
		filename = path
	End Method

End Type