Rem
'
' Copyright (c) 2007-2009 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TEditorImage Extends TParticleImage

	Method New()
		_name = "New Image"
		_handlePoint = HANDLE_CENTER
	End Method

	Function CreateGridProperty:wxPropertyCategory()
		Local prop:wxPropertyCategory  = New wxPropertyCategory.Create("Image", "image_category")
		PROPERTY_GRID.AppendIn( prop, New wxStringProperty.Create("Name", 			 PROP_NAME))
		PROPERTY_GRID.AppendIn( prop, New wxStringProperty.Create("Description", 	 PROP_DESCRIPTION))
		PROPERTY_GRID.AppendIn( prop, New wxFileProperty.Create( "File name", 		 PROP_FILENAME))
		PROPERTY_GRID.AppendIn( prop, New wxEnumProperty.CreateWithChoices("Handle", PROP_HANDLEPOINT, LIBRARY.GetHandleChoices() ))
		PROPERTY_GRID.AppendIn( prop, New wxStringProperty.Create("Resolution",		 PROP_RESOLUTION, 0))
		PROPERTY_GRID.AppendIn( prop, New wxIntProperty.Create("Frame size X",		 PROP_FRAMESIZEX, 0))
		PROPERTY_GRID.AppendIn( prop, New wxIntProperty.Create("Frame size Y", 		 PROP_FRAMESIZEY, 0))
		PROPERTY_GRID.AppendIn( prop, New wxIntProperty.Create("Frames", 			 PROP_FRAMECOUNT, 0))
		PROPERTY_GRID.SetPropertyReadOnly(PROP_RESOLUTION)
		PROPERTY_GRID.SetPropertyReadOnly(PROP_FRAMECOUNT)

		'pg.SetPropertyHelpString("editor_color_start", "Settings which affect the editor behaviour and look")
		Return prop
	End Function

	Method FillGridProperty()
		PROPERTY_GRID.SetPropertyValueString(	PROP_NAME, 			_name)
		PROPERTY_GRID.SetPropertyValueString(	PROP_DESCRIPTION, 	_description)
		PROPERTY_GRID.SetPropertyValueString(	PROP_RESOLUTION, "" + Self.GetImageWidth() + " x " + Self.GetImageHeight())
		PROPERTY_GRID.SetPropertyValueInt(		PROP_FRAMECOUNT, 	_frameCount)
		PROPERTY_GRID.SetPropertyValueInt(		PROP_FRAMESIZEX, 	_frameDimensionX)
		PROPERTY_GRID.SetPropertyValueInt(		PROP_FRAMESIZEY, 	_frameDimensionY)
		PROPERTY_GRID.SetPropertyValueString(	PROP_FILENAME, 		_imageFilename)
		PROPERTY_GRID.SetPropertyValueInt(		PROP_HANDLEPOINT,	_handlePoint)
	End Method

	Method ChangeSetting(Event:wxPropertyGridEvent, tree:wxTreeCtrl, treeItem:wxTreeItemId)', pg:wxPropertyGrid, lib:TEditorLibrary)
		Select Event.GetPropertyName()
			Case PROP_NAME
				Local text:String = Event.GetPropertyValueAsString()
				tree.SetItemText(treeItem, text)
				_name = text
			Case PROP_DESCRIPTION
				_description = Event.GetPropertyValueAsString()
			Case PROP_FILENAME
				Self.ChangeImage( Event.GetPropertyValueAsString() )
			Case PROP_FRAMESIZEX
				Self.SetFrameDimensionX(Event.GetPropertyValueAsInt())
			Case PROP_FRAMESIZEY
				Self.SetFrameDimensionY(Event.GetPropertyValueAsInt())
			Case PROP_HANDLEPOINT
				_handlePoint = Event.GetPropertyValueAsInt()
				If _image <> _baseImage Then Self.SetHandlePoint()
		End Select
		Self.FillGridProperty()
	End Method

	Method SetName(name:String)
		_name = name
	End Method

	Method SetDescription(desc:String)
		_description = desc
	End Method

	Method ChangeImage(newName:String)
		If newName = "" Then Return
		If newName = _imageFilename Then Return

		Local ok:Int = _LoadImage(newName)
		If ok
			_frameDimensionX = _baseImage.width
			_frameDimensionY = _baseImage.height
			_frameCount = 0
			_image = _baseImage
			_handlePoint = HANDLE_CENTER
		End If
	End Method

	Method SetFrameDimensionX(value:Int)
		If value <= 0 Or value > _baseImage.width Then value = _baseImage.width
		_frameDimensionX = value
		_DetermineFrameCount()
	End Method

	Method SetFrameDimensionY(value:Int)
		If value <= 0 Or value > _baseImage.height Then value = _baseImage.height
		_frameDimensionY = value
		_DetermineFrameCount()
	End Method

	Method GetImageWidth:Int()
		If _baseImage = Null Then Return 0
		Return _baseImage.width
	End Method

	Method GetImageHeight:Int()
		If _baseImage = Null Then Return 0
		Return _baseImage.height
	End Method

	Method CopySettingsTo( i:TEditorImage Var )
		i._name = "Copy of " + _name
		i._description = _description
		i._imageFilename = _imageFilename
		i._frameDimensionX = _frameDimensionX
		i._frameDimensionY = _frameDimensionY
		i._image = _image
		i._baseImage = _baseImage
		i._frameCount = _frameCount
		i._handlePoint = _handlePoint
	End Method

	Method SettingsToStream( s:TStream, imagePath:String="")
		s.WriteLine("#image")
		s.WriteLine("id=" + _id)
		s.WriteLine("name=" + _name)
		s.WriteLine("desc=" + _description)
		Local name:String = _imageFilename
		If imagePath <> "" Then name = imagePath + "/" + StripDir(name)
		s.WriteLine("imagepath=" + name)
		s.WriteLine("framex=" + _frameDimensionX)
		s.WriteLine("framey=" + _frameDimensionY)
		s.WriteLine("count=" + _frameCount)
		s.WriteLine("handle=" + _handlePoint)
		s.WriteLine("#endimage")
	End Method

	Method DrawBaseImage(dx:Float, dy:Float)
		If _baseImage = Null Then Return
		SetBlend ALPHABLEND
		SetAlpha 0.25
		SetColor 0,0,0
		DrawRect dx-_baseImage.width/2, dy-_baseImage.height/2, _baseImage.width, _baseImage.height
		SetAlpha 1.0
		SetColor 255,255,255
		DrawImage _baseImage, dx,dy
		SetAlpha 0.25
		SetColor 0,255,100
		Local x:Int, y:Int
		While y < _baseImage.height
			While x < _baseImage.width
				drawRectangle(x+dx - _baseImage.width/2, y+dy - _baseImage.height/2, _frameDimensionX, _frameDimensionY)
				x:+ _frameDimensionX
			Wend
			x=0
			y:+ _frameDimensionY
		Wend
	End Method

	'**** OVERRIDING METHODS *****

	Method SettingsFromStream( s:TStream )
		Local l:String, a:String[]
		l = s.ReadLine()
		l.Trim()
		While l <> "#endimage"
			a = l.split("=")
			Select a[0]
				Case "id"			_id = a[1]
				Case "name"			_name = a[1]
				Case "desc"			_description = a[1]
				Case "imagepath"	_imageFilename = a[1]
				Case "framex"		_frameDimensionX = Int( a[1] )
				Case "framey"		_frameDimensionY = Int( a[1] )
				Case "count"		_frameCount = Int( a[1] )
				Case "handle"		_handlePoint = Int( a[1] )
				Default 			DebugLog l
			End Select
			l = s.ReadLine()
			l.Trim()
		Wend
		_LoadImage(_imageFileName)
		If _frameCount > 1 Then _LoadMultiFrameImage
	End Method

	'***** PRIVATE *****

	Method _LoadImage:Int(name:String)
		Local tempImage:TImage = LoadImage( name )
		If tempImage = Null Then Return 0
		_baseImage = tempImage
		_image = _baseImage
		_imageFilename = name
		SetImageHandle(_baseImage, _baseImage.width/2, _baseImage.height/2)
		Return 1
	End Method

	Method _DetermineFrameCount()
		Local x:Int = _baseImage.width / _frameDimensionX
		Local y:Int = _baseImage.height / _frameDimensionY
		_frameCount = x * y
		If _frameCount = 1 Then Return
		_LoadMultiFrameImage()				'load extra anim image. keep single frame image
	End Method

	Method _LoadMultiFrameImage()
		Local tempImage:TImage = LoadAnimImage( _imageFilename, _frameDimensionX, _frameDimensionY, 0, _frameCount )
		If tempImage = Null Then Return
		_image = tempImage
		Self.SetHandlePoint()
	End Method

	Const PROP_NAME:String = "i1"
	Const PROP_DESCRIPTION:String = "i2"
	Const PROP_RESOLUTION:String = "i3"
	Const PROP_ID:String = "i4"
	Const PROP_FILENAME:String = "i5"
	Const PROP_FRAMESIZEX:String = "i6"
	Const PROP_FRAMESIZEY:String = "i7"
	Const PROP_FRAMECOUNT:String = "i8"
	Const PROP_HANDLEPOINT:String = "i9"

	Field _name:String
	Field _description:String
	Field _baseImage:TImage					' base image, only used in drawing in the editor.
End Type

Function DrawRectangle(x:Float, y:Float, w:Float, h:Float )
	DrawLine x,y, x+w,y
	DrawLine x,y, x,y+h
	DrawLine x+w,y, x+w,y+h
	DrawLine x, y+h, x+w, y+h
End Function
