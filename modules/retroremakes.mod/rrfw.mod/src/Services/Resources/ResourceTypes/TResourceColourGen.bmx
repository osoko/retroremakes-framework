Type TResourceColourGen Extends TResource

	Field colours:TColourGen
	
	Method Load(path:String)
		colours = TColourGen.Load(path)
		filename = path
	End Method
	
	Method GetResource:TColourGen()
		Return colours
	End Method
	
	Method Free()
		colours = Null
	End Method
	
End Type