rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TProjectionMatrix

	Const DEFAULT_GFX_PROJECTION_X:Float = 800.0
	Const DEFAULT_GFX_PROJECTION_Y:Float = 600.0
	Const DEFAULT_GFX_PROJECTION_ENABLED:Int = False
	Const DEFAULT_SCALE_TO_ASPECT_RATIO:Int = True
	
	' The Singleton instance of this class
  	Global _instance:TProjectionMatrix

	' Whether the projection matrix is enabled or not
	Field _enabled:Int

	' The height of the projection matrix
    Field _height:Float
	
	' Whether to scale the projection matrix to fit the physical display's aspect ratio
	Field _scaleToAspectRatio:Int
	
	' The width of the projection matrix
	Field _width:Float



	rem
		bbdoc: The the height of the projection matrix resolution
	endrem	
	Method GetHeight:Float()
		Return _height
	End Method
	
	
	
	rem
		bbdoc: Gets the Singleton instance of this class
	endrem	
	Function GetInstance:TProjectionMatrix()
		If Not _instance
			Return New TProjectionMatrix
		Else
			Return _instance
		EndIf
	End Function

	
	
	rem
		bbdoc: The the width of the projection matrix resolution
	endrem	
	Method GetWidth:Float()
		Return _width
	End Method
		
	
	
	rem
		bbdoc: Get whether the projection matrix is enabled or not
		returns: True if it is enabled, otherwise False
	endrem
	Method IsEnabled:Int()
		Return _enabled
	End Method
	
	
		
	rem
		bbdoc: Default constructor
	endrem
	Method New()
		If _instance Throw "Cannot create multiple instances of this Singleton Type"
		_instance = Self
		
		SetWidth(DEFAULT_GFX_PROJECTION_X)
		SetHeight(DEFAULT_GFX_PROJECTION_Y)
		SetEnabled(DEFAULT_GFX_PROJECTION_ENABLED:Int)
		SetScaleToAspectRatio(DEFAULT_SCALE_TO_ASPECT_RATIO)
	End Method

	

	rem
		bbdoc: Resets the projection matrix
	endrem
	Method Reset()
		TLogger.GetInstance().LogInfo("[" + toString() + "] Resetting")
		Set()
	End Method
	
	
	
	rem
		bbdoc: Sets the projection matrix
	endrem
	Method Set()
		If _scaleToAspectRatio
			TLogger.GetInstance().LogInfo("[" + toString() + "] Scaling to physical display's aspect ratio")

			Local displayAspectRatio:Float = TGraphicsService.GetInstance().GetAspectRatio()

			SetWidth(GetHeight() * displayAspectRatio)
		End If

		TLogger.GetInstance().LogInfo("[" + toString() + "] Settings projection matrix to " + Int(GetWidth()) + "x" + Int(GetHeight()))

		SetVirtualResolution(GetWidth(), GetHeight())
	End Method
	
	
	
	rem
		bbdoc: Enables or Disables the projection matrix
	endrem
	Method SetEnabled(bool:Int)
		_enabled = bool
		If _enabled
			rrSetBoolVariable("GFX_PROJECTION_ENABLED", "true", "Engine")
			TLogger.GetInstance().LogInfo("[" + toString() + "] Enabled")
		Else
			rrSetBoolVariable("GFX_PROJECTION_ENABLED", "false", "Engine")
			TLogger.GetInstance().LogInfo("[" + toString() + "] Disabled")
		End If
	End Method
	
	
		
	rem
		bbdoc: Sets the height of the projection matrix
	endrem
	Method SetHeight(height:Float)
		rrSetFloatVariable("GFX_PROJECTION_Y", height, "Engine")
		_height = height
	End Method
	
	
	
	rem
		bbdoc: Sets whether or not the projection matrix should scale to match the
		aspect ratio of the physical display
		about: Scaling of the projection matrix is performed on its width only, this
		means the height will always stay as you have set it, but the width may
		shrink or grow to ensure the aspect ratio stays in sync with the physical
		display.  This means you should always check for the screen width with the
		GetWidth() method or rrGetGraphicsWidth() helper function rather than rely
		on the width staying the same.  The default is to scale the projection matrix.
	endrem
	Method SetScaleToAspectRatio(scaleToAspectRatio:Int)
		_scaleToAspectRatio = scaleToAspectRatio
	EndMethod
	
	
		
	rem
		bbdoc: Sets the width of the projection matrix
	endrem
	Method SetWidth(width:Float)
		rrSetFloatVariable("GFX_PROJECTION_X", width, "Engine")
		_width = width
	End Method
	
	

	rem
		bbdoc: Get's the projected mouse X position
		about: If the projection matrix is enabled, the projected mouse position is
		returned, otherwise the standard MouseX() value is returned.
	endrem
	Method ProjectedMouseX:Float()
		If _enabled
			Return VirtualMouseX()
		Else
			Return Float(MouseX())
		End If
	End Method

	
	
	rem
		bbdoc: Get's the projected mouse Y position
		about: If the projection matrix is enabled, the projected mouse position is
		returned, otherwise the standard MouseY() value is returned.
	endrem	
	Method ProjectedMouseY:Float()
		If _enabled
			Return VirtualMouseY()
		Else
			Return Float(MouseY())
		End If
	End Method
	
	
	
	rem
		bbdoc: Project the provided mouse X position
	endrem
	Method ProjectMouseX:Float(x:Int)
		Return Float(x) / Float(GraphicsWidth()) * GetWidth()
	End Method
	
	
	
	rem
		bbdoc: Project the provided mouse Y position
	endrem	
	Method ProjectMouseY:Float(y:Int)
		Return Float(y) / Float(GraphicsHeight()) * GetHeight()
	End Method	
	     

	
	rem
		bbdoc: Returns a human readable representation of the class
	endrem
	Method ToString:String()
		Return "Projection Matrix"
	End Method
	
End Type



Function rrSetProjectionMatrixResolution(width:Float = 800.0, height:Float = 600.0, scaleToAspectRatio:Int = True)
	TProjectionMatrix.GetInstance().SetWidth(width)
	TProjectionMatrix.GetInstance().SetHeight(height)
	TProjectionMatrix.GetInstance().SetScaleToAspectRatio(scaleToAspectRatio)
End Function



Function rrGetProjectionMatrixWidth:Int()
	Return Int(TProjectionMatrix.GetInstance().GetWidth())
End Function



Function rrGetProjectionMatrixHeight:Int()
	Return Int(TProjectionMatrix.GetInstance().GetHeight())
End Function



Function rrResetProjectionMatrix()
	TProjectionMatrix.GetInstance().Reset()
End Function



Function rrCreateProjectionMatrix()
	TProjectionMatrix.GetInstance().Set()
End Function



Function rrEnableProjectionMatrix()
	TProjectionMatrix.GetInstance().SetEnabled(True)
End Function



Function rrDisableProjectionMatrix()
	TProjectionMatrix.GetInstance().SetEnabled(False)
End Function



Function rrProjectionMatrixEnabled:Int()
	Return TProjectionMatrix.GetInstance().IsEnabled()
End Function



Function rrGetProjectedMouseX:Float()
	Return TProjectionMatrix.GetInstance().ProjectedMouseX()
End Function



Function rrGetProjectedMouseY:Float()
	Return TProjectionMatrix.GetInstance().ProjectedMouseY()
End Function



Function rrGetProjectedMouse(myX:Float Var, myY:Float Var)
	Local projectionMatrix:TProjectionMatrix = TProjectionMatrix.GetInstance()
	myX = projectionMatrix.ProjectedMouseX()
	myY = projectionMatrix.ProjectedMouseY()
End Function
