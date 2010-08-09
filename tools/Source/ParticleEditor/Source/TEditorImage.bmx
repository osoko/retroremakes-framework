Rem
'
' Copyright (c) 2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: Extension of the library image, adding editor specific functionality
endrem
Type TEditorImage Extends TParticleImage

	'image property group in editor
	Global group:TPropertyGroup

	'only used for drawing of the complete image + frame boxes in the editor
	Field _baseImage:TImage
	
	'node in the treeview this object is attached to.
	Field node:TGadget

	'item ids. passed along with events to identify modified items
	Const PROP_NAME:Int = 100
	Const PROP_DESCRIPTION:Int = 101
	Const PROP_RESOLUTION:Int = 102
	Const PROP_FILENAME:Int = 103
	Const PROP_FRAMESIZEX:Int = 104
	Const PROP_FRAMESIZEY:Int = 105
	Const PROP_FRAMECOUNT:Int = 106
	Const PROP_HANDLEPOINT:Int = 107
	
	
	
	Method New()
		_editorName = "New Image"
		_handlePoint = HANDLE_CENTER
	End Method
	
	
	
	rem
	bbdoc: Sets node associated with this image
	about: Called when the user creates a new image
	endrem
	Method SetNode(n:TGadget)
		node = n
	End Method
	
	
	
	rem
	bbdoc: Creates the items in the image group
	about: The PROP_IDs are passed along in the events generated by the items.
	The global group field is set to the property group.
	endrem
	Method SetupGroupItems(grp:TPropertyGroup)
		group = grp
		CreatePropertyItemString("Name", "", PROP_NAME, group)
		CreatePropertyItemString("Description", "", PROP_DESCRIPTION, group)
		CreatePropertyItemPath("File Name", "", PROP_FILENAME, group)
		Local choice:TPropertyitemchoice = CreatePropertyItemChoice("Handle", PROP_HANDLEPOINT, group)
		choice.AddItem("Center")
		choice.AddItem("Left")
		choice.AddItem("Right")
		choice.AddItem("Top")
		choice.AddItem("Bottom")
		CreatePropertyItemString("Frame Size X", "", PROP_FRAMESIZEX, group)
		CreatePropertyItemString("Frame Size Y", "", PROP_FRAMESIZEY, group)
		CreatePropertyItemString("Resolution", "", PROP_RESOLUTION, group)
		CreatePropertyItemString("Frames", "", PROP_FRAMECOUNT, group)
	End Method
	

	
	rem
	bbdoc: Sets property group settings to those in the image
	about: Called when the user selects an image item in the editor
	Strings are case sensitive!
	endrem	
	Method SetPropertyGroupItems()
		group.SetStringByName("Name", _editorName)
		group.SetStringByName("Description", _description)
		group.SetStringByName("Resolution", GetImageWidth() + " x " + GetImageHeight())
		group.SetIntByName("Frames", _frameCount)
		group.SetIntByName("Frame Size X", _frameDimensionX)
		group.SetIntByName("Frame Size Y", _frameDimensionY)
		group.SetStringByName("File Name", _imageFilename)
		group.SetChoiceByName("Handle", _handlePoint)
	End Method
	
	
	
	rem
	bbdoc: Sets image settings to property group values
	endrem
	Method ApplyPropertyGroup()
		_editorName = group.GetStringByName("Name")
		_description = group.GetStringByName("Description")
		_frameCount = group.GetIntByName("Frames")
		_frameDimensionX = group.GetIntByName("Frame Size X")
		_frameDimensionY = group.GetIntByName("Frame Size Y")
		_handlePoint = group.GetIntByName("Handle")
	End Method
	
	
	
	rem
	bbdoc: Changes image setting according to changed item
	about: changed item is in eventsource(), the name is retrieved and then
	the value is retrieved from the group
	endrem
	Method ChangeSetting(i:TPropertyItem)
		Local label:String = i.GetName()
		Select label
			Case "Name"
				_editorName = group.GetStringByName(label)
				SetGadgetText(node, _editorName)
			Case "Description"
				_description = group.GetStringByName(label)
			Case "Frame Size X"
				_frameDimensionX = group.GetIntByName(label)
			Case "Frame Size Y"
				_frameDimensionY = group.GetIntByName(label)
			Case "Handle"
'				_handlePoint = group.GetChoiceByName(label,)
		End Select
	End Method

	
	
	
	Method GetImageWidth:Int()
		If _baseImage = Null Then Return 0
		Return _baseImage.width
	End Method

	Method GetImageHeight:Int()
		If _baseImage = Null Then Return 0
		Return _baseImage.height
	End Method	

	
	
	
	
	
	
	Method SetFrameDimensionX(value:Int)
		If value <= 0 Or value > _baseImage.width Then value = _baseImage.width
		_frameDimensionX = value
'		_DetermineFrameCount()
	End Method

	Method SetFrameDimensionY(value:Int)
		If value <= 0 Or value > _baseImage.height Then value = _baseImage.height
		_frameDimensionY = value
'		_DetermineFrameCount()
	End Method
	

	
	
	rem


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


	
	endrem
	
End Type

Function DrawRectangle(x:Float, y:Float, w:Float, h:Float )
	DrawLine x,y, x+w,y
	DrawLine x, y, x, y + h
	DrawLine x+w,y, x+w,y+h
	DrawLine x, y+h, x+w, y+h
End Function
