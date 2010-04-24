

Type particleTest Extends TTest

	Field p:TParticle
	
	Method setup() {before}
		p = New TParticle
	End Method
	
	Method cleanup() {after}
		p = Null
	End Method
	
	' Can we create a particle?
	Method testCreateParticle() {test}
		assertNotNull(p)
	End Method
	
	' Can we set the particle properties using a config string?
	Method testImportSettings() {test}
	
		Local array:String[48]
		
		array[0] = "particle"
		array[1] = "id1"
		array[2] = "editor name"
		array[3] = "description"
		array[4] = "id2"
		array[5] = "2"
		array[6] = "0.1"
		array[7] = "100"
		array[8] = String(LIGHTBLEND)
		
		'rotation
		array[09] = "float"
		array[10] = "1"
		array[11] = String(BEHAVIOUR_REPEAT)
		array[12] = "10"
		array[13] = "2.0"
		array[14] = "3.0"
		array[15] = "0.2"
	
		'alpha
		array[16] = "float"
		array[17] = "1"
		array[18] = String(BEHAVIOUR_REPEAT)
		array[19] = "10"
		array[20] = "2.0"
		array[21] = "3.0"
		array[22] = "0.2"
		
		'sizeX
		array[23] = "float"
		array[24] = "1"
		array[25] = String(BEHAVIOUR_REPEAT)
		array[26] = "10"
		array[27] = "2.0"
		array[28] = "3.0"
		array[29] = "0.2"
		
		'sizeY
		array[30] = "float"
		array[31] = "1"
		array[32] = String(BEHAVIOUR_REPEAT)
		array[33] = "10"
		array[34] = "2.0"
		array[35] = "3.0"
		array[36] = "0.2"
		
		'color
		array[37] = "color"
		array[38] = "1"
		array[39] = String(BEHAVIOUR_REPEAT)
		array[40] = "10"
		array[41] = "0.2"
		array[42] = "100"
		array[43] = "100"
		array[44] = "100"
		array[45] = "200"
		array[46] = "200"
		array[47] = "200"
	
		p.ImportSettings(array)
		
		'taking a sample from each imported part		
		assertEquals("editor name", p.GetEditorName())
		assertEqualsI(2, p._imageFrame)
		assertEqualsF(2.0, p._rotation._startValue)
		assertEqualsI(10, p._alpha._countdown_left)
		assertEqualsF(3.0, p._sizeX._endValue)
		assertEqualsF(2.0, p._sizeY._startValue)
		assertEqualsI(BEHAVIOUR_REPEAT, p._color.GetBehaviour())
	End Method

'export


'clone
'set image

End Type


