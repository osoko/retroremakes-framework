Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem


Const CHOICE_NONE:Int = -1

rem
bbdoc: Particle library with added functionality for the editor
endrem
Type TEditorLibraryConfiguration Extends TLibraryConfiguration

	Field _behaviourChoices:wxPGChoices						' value behaviour, 			use: values
	Field _blendChoices:wxPGChoices							' particle blend, 			use: particles
	Field _imageFrameChoices:wxPGChoices					' particle image frame, 	use: particles
	Field _shapeChoices:wxPGChoices							' emitter shape, 			use: emitters
	Field _spawnAngleChoices:wxPGChoices					' angle of to spawn object. use: emitter
	Field _handleChoices:wxPGChoices						' where to handle?			use: images

	Field _imageChoices:wxPGChoices							' particle image, 			use: particles
	Field _spawnChoices:wxPGChoices							' emitters and particles, 	use: emitters
	Field _appearanceChoices:wxPGChoices					' particles.				use: emitters
	Field _projectChoices:wxPGChoices						' emitters and effects, 	use: projects
	Field _emitterChoices:wxPGChoices						' eimtters					use: effects

	Method New()
		'SetupChoices()
	End Method

	rem
	
	Method SyncEmitterToEngine(s:TEditorEmitter)
		'
		'find emitter in 'live' list
		For Local sp:TEmitter = EachIn TEngineBase._objectList
			If sp._id = s._id
				s.SyncToEngine(sp)
			End If
		Next
	End Method

	method UpdateImageChoices()
		_imageChoices.Clear()
		_imageChoices.add("None", CHOICE_NONE )
		For Local i:TEditorImage = EachIn MapValues(library)
			_imageChoices.Add(i._name, Int(i._id))
		Next
	End Method

	Method UpdateImageFrameChoices(img:TEditorImage)
		_imageFrameChoices.Clear()
		_imageFrameChoices.Add("0", 0 )
		If img._frameCount > 1 Then
			For Local frames:Int = 1 To img._frameCount -1						' -1, we already have choice 0
				_imageFrameChoices.Add(String(frames), frames )
			Next
			_imageFrameChoices.Add("RND", -1 )
		EndIf
	End Method

	Method UpdateAppearanceChoices()
		_appearanceChoices.Clear()
		_appearanceChoices.add("None", CHOICE_NONE )
		For Local i:TEditorParticle = EachIn MapValues(library)
			_appearanceChoices.Add("Particle: " + i._name, Int(i._id))
		Next
	End Method

	Method UpdateSpawnChoices(exclude:TEditorEmitter)
		_spawnChoices.Clear()
		 _spawnChoices.add("None", CHOICE_NONE )
		For Local i:TEditorEmitter = EachIn MapValues(library)
			If i = exclude Then Continue
			_spawnChoices.Add("Emitter: " + i._name, Int(i._id))
		Next
		For Local i:TEditorParticle = EachIn MapValues(library)
			_spawnChoices.Add("Particle: " + i._name, Int(i._id))
		Next
	End Method

	Method UpdateEmitterChoices()
		_emitterChoices.Clear()
		_emitterChoices.add("None", CHOICE_NONE )
		For Local e:TEditorEmitter = EachIn MapValues(library)
			_emitterChoices.Add(e._name, Int(e._id))
		Next
	End Method

	Method UpdateProjectChoices()
		_projectChoices.Clear()
		_projectChoices.add("None", CHOICE_NONE )
		For Local i:TEditorEmitter = EachIn MapValues(library)
			_projectChoices.Add("Emitter: " + i._name, Int(i._id))
		Next
		For Local ef:TEditorEffect = EachIn MapValues(library)
			_projectChoices.Add("Effect: " + ef._name, Int(ef._id))
		Next

	End Method



	Method RemoveImage:Int(i:TEditorImage)
		'
		'used by particles?
		Local found:Int = 0
		For Local p:TEditorParticle = EachIn MapValues(library)
			If p._image = i Then found:+1
		Next
		If found > 0
			Local choice:Int = Confirm("This image is used by one or more particles!~rDeleting it will also remove the image from those objects.~rAre you sure?",1)
			If choice = False Then Return False
		EndIf
		For Local p:TEditorParticle = EachIn MapValues(library)
			If p._image = i Then p._image = Null
		Next
		MapRemove( library, i._id)
		Return True
	End Method

	Method RemoveParticle:Int(p:TEditorParticle)
		Local found:Int = 0
		For Local s:TEditorEmitter = EachIn MapValues(library)
			Local sp:TEditorParticle = TEditorParticle(s.GetSpawnObject() )
			If sp = p Then found:+1
		Next
		If found > 0
			Local choice:Int = Confirm("This particle is used by one or more emitters!~rDeleting it will also remove the particle from those objects.~rAre you sure?",1)
			If choice = False Then Return False
		EndIf

		For Local s:TEditorEmitter = EachIn MapValues(library)
			Local sp:TEditorParticle = TEditorParticle(s.GetSpawnObject() )
			If sp = p Then s.SetSpawnObject(Null)
		Next
		MapRemove( library, p._id)
		Return True
	End Method

	Method RemoveEmitter:Int(e:TEditorEmitter)
		Local found:Int = 0
		For Local p:TEditorProject = EachIn MapValues(library)
			For Local e1:TEditorEmitter = EachIn p._childList
				If e1 = e Then found:+1
			Next
		Next
		For Local p:TEditorEffect = EachIn MapValues(library)
			For Local e1:TEditorEmitter = EachIn p._childList
				If e1 = e Then found:+1
			Next
		Next

		If found > 0
			Local choice:Int = Confirm("This emitter is used by one or more effects or projects!~rDeleting it will also remove the emitter from those objects.~rAre you sure?",1)
			If choice
				For Local p:TEditorProject = EachIn MapValues(library)
					ListRemove( p._childList, e )
				Next
			Else
				Return False		' no remove
			EndIf
		EndIf
		MapRemove( library, e._id)
		Return True
	End Method

	Method RemoveEffect:Int(s:TEditorEffect)
		Local found:Int = 0
		For Local p:TEditorProject = EachIn MapValues(library)
			'
			'check the list of effects in this project
			For Local s1:TEditorEffect = EachIn p._childList
				If s1 = s Then found:+1
			Next
		Next

		If found > 0
			Local choice:Int = Confirm("This effect is used by one or more projects!~rDeleting it will also remove it from those objects.~rAre you sure?",1)
			If choice
				'
				'remove this effect from each project list
				For Local e:TEditorProject = EachIn MapValues(library)
					ListRemove( e._childList, s )
				Next
			Else
				Return False		' no remove
			EndIf
		EndIf
		MapRemove( library, s._id)
		Return True
	End Method

	Method RemoveProject(p:TEditorProject)
		MapRemove( library, p._id)
	End Method

	Method ExportProject(p:TEditorProject, Event:wxEvent)
		If p._filename = "" Then
			p._filename = wxGetTextFromUser("Enter a name for the configuration file:", "filename: ", ".txt", MAIN_FRAME(Event.parent))
			If p._filename = "" Then Return
			If p._filename[p._filename.length-4..p._filename.length] <> ".txt" Then p._filename:+ ".txt"
		EndIf

		Local items:TList = New TList

		'
		'export effects
		For Local ef:TEditorEffect = EachIn p._childList
			If items.Contains(ef) = False Then items.AddLast(ef)
			ExportEmitters( ef._childList, items)
		Next
		'
		'export emitters which are not included in an effect
		ExportEmitters( p._childList, items)

		'the list is built.
		'export strings to file. order is : images, particles, emitters, effects
		Local out:TStream = WriteStream(p._filename)
		If out = Null Then Notify "Save failed!" ; Return

		For Local im:TEditorImage = EachIn items
			im.SettingsToStream(out)
		Next
		For Local pa:TEditorParticle = EachIn items
			pa.SettingsToStream(out)
		Next
		For Local em:TEditorEmitter = EachIn items
			em.SettingsToStream(out)
		Next
		For Local ef:TEditorEffect = EachIn items
			ef.SettingsToExportStream(out)				' to force emitter's _gameName, and not _id's.
		Next
		out.Close()
		Notify "Project '" + p._name + "' exported succesfully to '" + p._filename + "'"
	End Method

	Method ExportEmitters( l:TList, items:TList)
		For Local em:TEditorEmitter = EachIn l
			If items.Contains(em) = False Then items.AddLast(em)

			Local appearance:TEditorParticle = em.GetAppearanceParticle()
			If appearance <> Null
				If items.Contains(appearance) = False Then items.Addlast( appearance )
				If items.Contains(appearance._image) = False Then items.AddLast(appearance._image)
			EndIf
			If TEditorParticle(em.GetSpawnObject() )
				Local spawn:TEditorParticle = TEditorParticle( em.GetSpawnObject() )
				If items.Contains(spawn) = False Then items.Addlast( spawn )
				If items.Contains(spawn._image) = False Then items.AddLast(spawn._image)
			End If
			If TEditorEmitter(em.GetSpawnObject() )
				Local spawn:TEditorEmitter = TEditorEmitter( em.GetSpawnObject() )
				If items.Contains(spawn) = False Then items.Addlast( spawn )
			End If
		Next
	End Method
	
	
endrem

	rem
	bbdoc: Clears the editor library
	endrem
	Method Clear()
		library.Clear()
	End Method

	rem

	'***** SPAWN METHODS *****

	Method SpawnObject(o:Object, x:Int,y:Int)
		If TEditorParticle(o)
			Local p:TParticle = TEditorParticle(o).CloneToEngine(Null)
			If p Then p.SetPosition(x,y)
		End If
		If TEditorEmitter(o)
			Local e:TEmitter = TEditorEmitter(o).CloneToEngine(Null)
			e.SetPosition(x,y)
			e.Enable()
		End If
		If TEditorEffect(o)
			Local effect:TEditorEffect = TEditorEffect(o)
			Local children:TList = effect.GetChildren()
			For Local ee:TEditorEmitter = EachIn children
				Local e:TEmitter = ee.CloneToEngine(Null)
'				e.SetPosition(x,y)
				e.SetPosition( x+ e._offsetX.getValue(), y + e._offsetX.GetValue() )
				e.Enable()
			Next
		End If
	End Method

	'***** RETRIEVAL METHODS *****

	Method GetImages:TList()
		Local list:TList = New TList
'		for 
	End Method

	Method GetImageChoices:wxPGChoices()
		Return _imageChoices
	End Method

	Method GetImageFrameChoices:wxPGChoices()
		Return _imageFrameChoices
	End Method

	Method GetSpawnChoices:wxPGChoices()
		Return _spawnChoices
	End Method

	Method GetEmitterChoices:wxPGChoices()
		Return _emitterChoices
	End Method

	Method GetAppearanceChoices:wxPGChoices()
		Return _appearanceChoices
	End Method

	Method GetHandleChoices:wxPGChoices()
		Return _handleChoices
	End Method

	Method GetSpawnAngleChoices:wxPGChoices()
		Return _spawnAngleChoices
	End Method

	Method GetProjectChoices:wxPGChoices()
		Return _projectChoices
	End Method

	Method GetBlendChoices:wxPGChoices()
		Return _blendChoices
	End Method

	Method GetBehaviourChoices:wxPGChoices()
		Return _behaviourChoices
	End Method

	Method GetShapeChoices:wxPGChoices()
		Return _shapeChoices
	End Method

	'***** OVERLOADED METHODS *****

	Method GetImage:TEditorImage(id:String)
		Return TEditorImage( MapValueForKey( library, id ) )
	End Method

	Method GetParticle:TEditorParticle(id:String)
		Return TEditorParticle( MapValueForKey( library, id ) )
	End Method

	Method GetEmitter:TEditorEmitter(id:String)
		Return TEditorEmitter( MapValueForKey( library, id ) )
	End Method

	Method GetEffect:TEditorEffect(id:String)
		Return TEditorEffect( MapValueForKey( library, id ) )
	End Method

endrem
		
	rem
	bbdoc: Sets up pull down choices
	endrem
	
	rem
	Method SetupChoices()
		
		'static choices
		_behaviourChoices = New wxPGChoices.Create()
			_behaviourChoices.Add("Stop", 		BEHAVIOUR_ONCE)
			_behaviourChoices.Add("Restart", 	BEHAVIOUR_REPEAT)
			_behaviourChoices.Add("Ping Pong",	BEHAVIOUR_PINGPONG)
		_blendChoices = New wxPGChoices.Create()
			_blendChoices.Add("Light blend", 	LIGHTBLEND)
			_blendChoices.Add("Alpha blend", 	ALPHABLEND)
			_blendChoices.Add("Shade blend", 	SHADEBLEND)
			_blendChoices.Add("Solid blend", 	SOLIDBLEND)
		_shapeChoices = New wxPGChoices.Create()
			_shapeChoices.Add("Oval",			STYLE_RADIAL)
			_shapeChoices.Add("Square",			STYLE_BOX)
			_shapeChoices.Add("Fountain",		STYLE_FOUNTAIN)
			_shapeChoices.Add("Line",			STYLE_LINE)

		_handleChoices = New wxPGChoices.Create()
			_handleChoices.add("Center",		HANDLE_CENTER)
			_handleChoices.add("Top",			HANDLE_TOP)
			_handleChoices.add("Bottom",		HANDLE_BOTTOM)
			_handleChoices.add("Left",			HANDLE_LEFT)
			_handleChoices.add("Right",			HANDLE_RIGHT)

		_spawnAngleChoices = New  wxPGChoices.Create()
			_spawnAngleChoices.add("Align with emitter", ANGLE_EMITTER)
			_spawnAngleChoices.add("Random", ANGLE_RANDOM)
			_spawnAngleChoices.add("Use item setting", ANGLE_PARTICLE)

		
		'dynamic choices
		_imageChoices = New wxPGChoices.Create()
		UpdateImageChoices()

		_imageFrameChoices = New wxPGChoices.Create()
		_imageFrameChoices.Add("None", CHOICE_NONE)

		_spawnChoices = New wxPGChoices.Create()
		UpdateSpawnChoices(Null)

		_emitterChoices = New wxPGChoices.Create()
		UpdateEmitterChoices()

		_projectChoices = New wxPGChoices.Create()
		UpdateProjectChoices()

		_appearanceChoices = New wxPGChoices.Create()
		UpdateAppearanceChoices()

	End Method
	
	endrem

End Type
