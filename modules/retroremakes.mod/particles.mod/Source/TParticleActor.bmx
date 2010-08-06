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
bbdoc: base object for all particle engine objects
endrem
Type TParticleActor Extends TActor Abstract

	'id in library
	Field _libraryID:Int

	'name in-game
	Field _gameName:String
		
	'friendly name in editor
	Field _editorName:String
	
	'handy text
	Field _description:String
	
	'x scale of object
	Field _sizeX:TFloatValue
	
	'y scale of object
	Field _sizeY:TFloatValue
	
	'rotation of object
	Field _rotation:TFloatValue
	
	'object friction while traveling (slow down factor)
	Field _friction:Float

	'current speed of object
	Field _velocity:TVector2D
	
	'acceleration of object
	Field _acceleration:TVector2D
	
	'life of object. 
	Field _life:Int
	
	'list of children this object has
	Field _childList:TList
	
	'parent of this object
	Field _parent:TActor

	

	Method Render(tweening:Double, fixed:Int) Abstract
	
	
	
	rem
	bbdoc: default contructor
	endrem		
	Method New()
		_sizeX = New TFloatValue
		_sizeY = New TFloatValue
		_rotation = New TFloatValue
		_velocity = New TVector2D
		_acceleration = New TVector2D
	End Method
	
	
	
	rem
	bbdoc: Sets ID of this object
	endrem
	Method SetID(newID:Int)
		_libraryID = newID
	End Method
	
	
	
	rem
	bbdoc: Returns this objects' ID
	endrem
	Method GetID:Int()
		Return _libraryID
	End Method
	
	
	
	rem
	bbdoc: Sets GameName of this object
	endrem
	Method SetGameName(name:String)
		_gameName = name
	End Method
	
	
	
	rem
	bbdoc: Returns this objects' gamename
	endrem
	Method GetGameName:String()
		Return _gameName
	End Method
	

		
	rem
	bbdoc: Sets editor name
	endrem
	Method SetEditorName(name:String)
		_editorName = name
	End Method

		

	rem
	bbdoc: Returns this objects' editorname
	endrem
	Method GetEditorName:String()
		Return _editorName
	End Method

	
	
	rem
	bbdoc: Sets description text
	endrem
	Method SetDescription(name:String)
		_description = name
	End Method

		

	rem
	bbdoc: Returns this objects' description text
	endrem
	Method GetDescription:String()
		Return _description
	End Method	

	
	
	rem
	bbdoc: Updates TParticleActor parameters
	about: A derived object must call Super.Update() in its update method
	endrem	
	Method Update()
		_sizeX.Update()
		_sizeY.Update()
		_rotation.Update()
		
		ApplyPhysics()
		UpdateLife()
	End Method

	
	
	rem
	bbdoc: Update life value
	returns: False when life has run out
	endrem
	Method UpdateLife:Int()
		If _life = -1 Then Return True
		_life:-1
		If _life = 0 Then Return False
		Return True
	EndMethod


	
	rem
	bbdoc: Removes this object from the particle engine
	endrem
	Method RemoveFromEngine()
		
		'...break free from parent
		If _parent Then TParticleActor(_parent).RemoveChild(Self)
		
		'...free children
		Self.RemoveAllChildren()
		
		TLayerManager.GetInstance().RemoveRenderable(Self)
		
	End Method
	
		
	rem
	bbdoc: Applies physics to this object
	endrem	
	Method ApplyPhysics()

		'we do not use TActor.UpdatePreviousPosition() as that also updates
		'the animation manager
		_previousPosition.SetV(_currentPosition)

		'apply friction to current velocity
		_velocity.MulF(1.0 - _friction)
		
		'add acceleration (divide by update frequency for fixed step) to velocity
		Local freq:Double = TFixedTimestep.GetInstance().GetUpdateFrequency()
		_velocity.AddF(_acceleration.x / freq, _acceleration.y / freq)

		'add velocity to the position		
		_currentPosition.AddV(_velocity)
		
		'get rid of acceleration for the next step
		_acceleration.Set(0, 0)
		
	End Method
	
	
		
	rem
	bbdoc: Set the acceleration by passing a vector
	endrem
	Method SetAcceleration(vec:TVector2D)
		_acceleration.Set(vec.x, vec.y)
	End Method

	
		
	rem
	bbdoc: Adds passed vector to acceleration
	endrem
	Method AddAcceleration(vec:TVector2D)
		_acceleration.AddV(vec)
	End Method

	
		
	rem
	bbdoc: Returns the acceleration vector
	endrem
	Method GetAcceleration:TVector2D()
		Return _acceleration
	End Method
	
	
	
	rem
	bbdoc: Moves position by specified 2D vector
	about: Also moves the previous position so basically, this is a 'scroll' operation
	endrem
	Method MovePosition(amount:TVector2D)
		_currentPosition.AddV(amount)
		_previousPosition.AddV(amount)
	End Method
	
	
	
	rem
	bbdoc: Change rotation angle of this object
	about: Takes changeable value into account
	endrem
	Method ChangeRotation(amount:Float)
		_rotation.MoveRange(amount)
	End Method
	
	
	
	rem
	bbdoc: Returns distance to passed vector
	endrem
	Method DistanceTo:Float(otherPosition:TVector2D)
		Return _currentPosition.Distance(otherPosition)
	End Method
		
	

	rem
	bbdoc: Returns the velocity vector of this object
	endrem
	Method GetVelocity:TVector2D()
		Return _velocity
	End Method

		
	
	rem
	bbdoc: Sets life of this object in ticks
	about: -1 = never die
	endrem	
	Method SetLife(val:Int)
		If val < -1 Then val = -1
		_life = val
	End Method
	
	
	
	rem
	bbdoc: Returns the remaining life of this object
	endrem
	Method GetLife:Int()
		Return _life
	End Method
	
		
	
	rem
	bbdoc: Returns the friction of this object
	endrem
	Method GetFriction:Float()
		Return _friction
	End Method
	
	
	
	rem
	bbdoc: Sets the friction of this object
	endrem	
	Method SetFriction(amount:Float)
		_friction = amount
	End Method
	
	

	rem
	bbdoc: Sets parent of this object
	about: Also adds this object as child to parent, if parent is not Null
	endrem
	Method SetParent(p:TActor)
		_parent = p
		If _parent Then TParticleActor(p).AddChild(Self)
	End Method
	
		
	
	rem
	bbdoc: Returns the parent of this object
	returns: TActor
	endrem	
	Method GetParent:TActor()
		Return _parent
	End Method

		
	
	rem
	bbdoc: Adds a child to this object
	endrem	
	Method AddChild(o:Object)
		If Not _childList Then _childList = New TList
		If _childList.Contains(o) Then Return
		_childList.AddLast(o)
		TParticleActor(o).SetParent(Self)
	End Method

		
	
	rem
	bbdoc: Removes child from this object
	endrem	
	Method RemoveChild(o:Object)
		If Not _childList Then Return
		TParticleActor(o).SetParent(Null)
		_childList.Remove(o)
	End Method
	
	
	
	rem
	bbdoc: Removes all children from this object
	endrem
	Method RemoveAllChildren()
		If Not _childList Then Return
		For Local p:TParticleActor = EachIn _childList
			RemoveChild(p)
		Next
	End Method
	
	
	
	rem
	bbdoc: Returns the list of children
	returns: TList
	endrem
	Method GetChildren:TList()
		Return _childList
	End Method
	
	
	
	rem
		bbdoc: rotates children around the position of this object
		about: also rotates the children (if present) of each child using recursive calls
	endrem
	Method RotateChildren(amount:Float)
		If Not _childList Then Return
		For Local b:TParticleActor = EachIn _childList
		
			b._currentPosition.RotateAbout(_currentPosition, amount)
			
			'rotate child rotation angle
			b.ChangeRotation(amount)
			
			'rotate child direction of travel
			b._velocity.Rotate(amount)
			b._acceleration.Rotate(amount)

			'rotate children of this child
			b.RotateChildren(amount)
		Next
	End Method	
		
End Type
