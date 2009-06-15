Type TResourceImage Extends TResource

	Field image:TImage
	Field flags:Int
	
	Method Load(path:String, flags:Int = -1)
		image = LoadImage(path, flags)
		filename = path
	End Method
	
	Method GetResource:TImage()
		Return image
	End Method

	Method Free()
		image = null
	End Method
		
End Type