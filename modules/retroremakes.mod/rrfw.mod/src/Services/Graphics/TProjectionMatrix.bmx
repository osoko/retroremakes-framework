Type TProjectionMatrix Extends TGameService

	Const DEFAULT_GFX_PROJECTION_X:Float = 800.0
	Const DEFAULT_GFX_PROJECTION_Y:Float = 600.0
	Const DEFAULT_GFX_PROJECTION_SCALE:Float = 1.0
	Const DEFAULT_GFX_PROJECTION_ENABLED:String = "false"
	
	Const DIRECTX7:Int = 7
	Const DIRECTX9:Int = 9
	
   Global instance:TProjectionMatrix
	
	Field width:Float
   Field Height:Float
	Field scale:Float
	Field enabled:Int
	
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
	
	Function Create:TProjectionMatrix()
		Return TProjectionMatrix.GetInstance()
	End Function
		
	Function GetInstance:TProjectionMatrix()
		If Not instance
			Return New TProjectionMatrix
		Else
			Return instance
		EndIf
	EndFunction

	Method Initialise()
		SetName("Projection Matrix")
		Super.Initialise()
	End Method
	
	Method GetWidth:Float()
		Return width
	End Method
	
	Method GetHeight:Float()
		Return height
	End Method
	
	Method GetScale:Float()
		Return scale
	End Method
	
	Method SetScale( scale:Float )
		rrSetFloatVariable("GFX_PROJECTION_SCALE", scale, "Engine")
		Self.scale = scale
	End Method
	
	Method SetWidth( myWidth:Float )
		rrSetFloatVariable("GFX_PROJECTION_X", myWidth, "Engine")
		width = myWidth
	End Method
	
	Method SetHeight( myHeight:Float )
		rrSetFloatVariable("GFX_PROJECTION_Y", myHeight, "Engine")
		height = myHeight
	End Method
	
	Method Enable()
		enabled = True
		rrSetBoolVariable("GFX_PROJECTION_ENABLED", "true", "Engine")
		TGameEngine.GetInstance().LogInfo("Projection Matrix Enabled")
	End Method
	
	Method Disable()
		enabled = False
		rrSetBoolVariable("GFX_PROJECTION_ENABLED", "false", "Engine")
		TGameEngine.GetInstance().LogInfo("Projection Matrix Disabled")
	End Method
	
	Method IsEnabled:Int()
		Return enabled
	End Method
	
	Method Reset()
		Set()
		TGameEngine.GetInstance().LogInfo("Projection Matrix Resetting")
	End Method
	
	Method Set()
		Local Driver:String = TGraphicsService.GetInstance().GetDriver()

		Select Driver
			Case "DirectX7"
				SetDirectXMatrix(DIRECTX7)
			Case "DirectX9"
				SetDirectXMatrix(DIRECTX9)
			Case "OpenGL"
				SetOpenGlMatrix()
		End Select

		TGameEngine.GetInstance().LogInfo("Projection Matrix Set to " + Width + " * " + Height + ", scale: " + scale)
	End Method

	Method SetDirectXMatrix(directXVersion:Int)
		?Win32
			Local matrix:Float[] = ..
			[..
				2.0 / (Self.Width / Self.scale) ,    0.0,    0.0,    0.0, ..
				0.0,   -2.0 / (Self.Height / Self.scale),    0.0,    0.0, ..
				0.0,   0.0,    1.0,    0.0, ..
				-1-( 1.0 / Self.Width ), 1+( 1.0 / Self.Height ), 1.0, 1.0 ..
			]
			
			If directXVersion = DIRECTX7 And TD3D7Max2DDriver(_max2dDriver) <> Null
				TD3D7Max2DDriver(_max2dDriver).device.SetTransform(D3DTS_PROJECTION, matrix)
			ElseIf directXVersion = DIRECTX9 And TD3D9Max2DDriver(_max2dDriver) <> Null
				TD3D9Max2DDriver(_max2dDriver)._D3DDevice9.SetTransform(D3DTS_PROJECTION, matrix)
			Else
				Throw "Unable to set DirectX Projection Matrix"
			EndIf
		?
	End Method
	
	Method SetOpenGlMatrix()
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity()
		glOrtho(0, (Self.Width / Self.scale), (Self.Height / Self.scale), 0, -1, 1)
		glMatrixMode(GL_MODELVIEW)	
	End Method
	
	Method ProjectedMouseX:Float()
		Return ( MouseX() / Float( GraphicsWidth() ) ) * Self.width
	End Method

	Method ProjectedMouseY:Float()
		Return ( MouseY() / Float( GraphicsHeight() ) ) * Self.height
	End Method
	
	Method ProjectMouseX:Float(x:Int)
		Return Float(x) / Float(GraphicsWidth()) * Self.Width
	End Method
	
	Method ProjectMouseY:Float(y:Int)
		Return Float(y) / Float(GraphicsHeight()) * Self.height
	End Method	
	     
End Type

Function rrSetProjectionMatrixResolution(Width:Float = 800.0, Height:Float = 600.0, scale:Float = 1.0)
	TProjectionMatrix.GetInstance().SetWidth(Width)
	TProjectionMatrix.GetInstance().SetHeight(Height)
	TProjectionMatrix.GetInstance().SetScale(scale)	
End Function

Function rrGetProjectionMatrixWidth:Int()
	Return Int(TProjectionMatrix.GetInstance().GetWidth())
End Function

Function rrGetProjectionMatrixHeight:Int()
	Return Int(TProjectionMatrix.GetInstance().GetHeight())
End Function

Function rrGetProjectionMatrixScale:Float()
	Return TProjectionMatrix.GetInstance().GetScale()
End Function

Function rrResetProjectionMatrix()
	TProjectionMatrix.GetInstance().Reset()
End Function

Function rrCreateProjectionMatrix()
	TProjectionMatrix.GetInstance().Set()
End Function

Function rrEnableProjectionMatrix()
	TProjectionMatrix.GetInstance().Enable()
End Function

Function rrDisableProjectionMatrix()
	TProjectionMatrix.GetInstance().Disable()
End Function

Function rrProjectionMatrixEnabled:Int()
	Return TProjectionMatrix.GetInstance().IsEnabled()
End Function

Function rrGetProjectedMouseX:Float()
	If rrProjectionMatrixEnabled()
		Return TProjectionMatrix.GetInstance().ProjectedMouseX()
	Else
		Return Float(MouseX())
	EndIf	
End Function

Function rrGetProjectedMouseY:Float()
	If rrProjectionMatrixEnabled()
		Return TProjectionMatrix.GetInstance().ProjectedMouseY()
	Else
		Return Float(MouseY())
	EndIf	
End Function

Function rrGetProjectedMouse(myX:Float Var, myY:Float Var)
	myX = rrGetProjectedMouseX()
	myY = rrGetProjectedMouseY()
End Function
