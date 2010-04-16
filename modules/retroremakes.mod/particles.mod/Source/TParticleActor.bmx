Rem
'
' Copyright (c) 2009-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
	bbdoc: base object for all particle engine objects
	about: includes information and methods needed for particle and emitters.
	This adds the functionality needed for emitters and particles and 
	some editor/library related fields.
endrem
Type TParticleActor Extends TActor Abstract

	'id in library
	Field _libraryID:String

	'name in-game
	Field _gameName:String
		
	'friendly name in editor
	Field _name:String
	
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
	
	'life of object. -1 is: never die
	Field _life:Int
	
	'list of children this object has
	Field _childList:TList
	
	'parent of this object
	Field _parent:TActor


	Method Render(tweening:Double, fixed:Int) Abstract
	
	rem
		bbdoc:default contructor
	endrem		
	Method New()
		_sizeX = New TFloatValue
		_sizeY = New TFloatValue
		_rotation = New TFloatValue
		_velocity = New TVector2D
		_acceleration = New TVector2D
	End Method
	
	'remove object
	Method Remove()
	
		'...from layer
		TLayerManager.GetInstance().RemoveRenderable(Self)
		
		'...from parent childlist if needed
		If _parent
			If TParticleActor(_parent) Then TParticleActor(_parent).RemoveChild(Self)
		EndIf
		
		'free children if needed...
		If _childList
			For Local a:TParticleActor = EachIn _childList
				a.RemoveParent()
			Next
		End If
		
	End Method

	rem
		bbdoc:updates TParticleActor basics
		about:A derived object must call Super.Update() in its update method
	endrem	
	Method Update()
	
		'update basic values
		_sizeX.Update()
		_sizeY.Update()
		_rotation.Update()
	
		'update position by applying basic physics

		'we do not use TActor.UpdatePreviousPosition() as that also updates the animation manager
		_previousPosition.SetV(_currentPosition)

		'apply friction to current speed
		_velocity.MulF(1.0 - _friction)
'		_velocity.Multiply(1.0 - _friction, 1.0 - _friction)
		
		'add acceleration (divide by update frequency for fixed step) to velocity
		Local freq:Double = TFixedTimestep.GetInstance().GetUpdateFrequency()
		_velocity.AddF(_acceleration.x * freq, _acceleration.y * freq)
		'_velocity.Add(_acceleration.x * freq, _acceleration.y * freq)

		'add velocity to the position		
		_currentPosition.AddV(_velocity)
		
		'get rid of acceleration for the next step
		_acceleration.Set(0, 0)
		
		'update life, remove if dead.
		If _life = -1 Then Return
		_life:-1
		If _life = 0 Then Self.Remove()
		
	End Method

	rem
		bbdoc:rotates current position around passed origin position
	endrem
'	Method RotatePosition(amount:Float, origin:TVector2d)
'		Local v:TVector2D = New TVector2D
'		v.Set(_currentPosition.x - origin.x, _currentPosition.y - origin.y)
'		v.Rotate(amount)
'		v.Add(origin.x, origin.y)
'		SetPosition.Set(v.x, v.y)
'	End Method


	rem
		bbdoc:moves position by specified 2D vector
		about:also moves the previous position so in effect, this is a 'scroll' operation
	endrem
	Method MovePosition(amount:TVector2D)
		_currentPosition.AddV(amount)
		_previousPosition.AddV(amount)
	End Method
	
	rem
		bbdoc:change rotation angle of this object
		about:takes changeable value into account
	endrem
	Method ChangeRotation(amount:Float)
		_rotation.Slide(amount)
	End Method
	
	rem
		bbdoc:get distance of this object to specified 2d vector
	endrem
	Method DistanceTo:Float(otherPosition:TVector2D)
		Return _currentPosition.Distance(otherPosition)
	End Method
		
'	Method GetChangedPosition:TVector2D()
'		Local c:TVector2D = New TVector2D
'		c.x = _currentPosition.x - _previousPosition.x
'		c.y = _currentPosition.y - _previousPosition.y
'		Return c
'	End Method

	Method GetVelocity:TVector2D()
		Return _velocity
	End Method
	
	rem
		bbdoc:accelerate this object by passed 2d vector
	endrem	
	Method AddAcceleration(amount:TVector2D)
		'_acceleration.SetV(amount)
		_acceleration.AddV(amount)
	End Method
	
	Method GetAcceleration:TVector2D()
		Return _acceleration
	End Method
	
	rem
		bbdoc:sets lifetime of this object in ticks
	endrem	
	Method SetLife(val:Int)
		If val < -1 Then val = -1
		_life = val
	End Method
	
	Method GetFriction:Float()
		Return _friction
	End Method
	
	Method SetFriction(amount:Float)
		_friction = amount
	End Method
	
'#region family management

	Method SetParent(p:TActor)
		_parent = p
	End Method
	
	Method RemoveParent()
		_parent = Null
	End Method
	
	rem
		bbdoc:returns the parent of this object
		returns:TActor
	endrem	
	Method GetParent:TActor()
		Return _parent
	End Method
	
	Method AddChild(o:Object)
		If Not _childList Then _childList = New TList
		If _childList.Contains(o) Then Return
		_childList.AddLast(o)
	End Method

	Method RemoveChild(o:Object)
		If Not _childList Then Return
		_childList.Remove(o)
	End Method

	Method GetChildren:TList()
		Return _childList
	End Method
	
	rem
		bbdoc: rotates children around the position of this object
		about: also rotates the children (if present) of each child using recursive calles
	endrem
	Method RotateChildren(amount:Float)
		If Not _childList Then Return
		For Local b:TParticleActor = EachIn _childList
		
			'rotate child position around position of this object
			b._currentPosition.RotateAbout(_currentPosition, amount)
'			b.RotatePosition(amount, _currentPosition)
			
			'rotate child rotation angle
			b.ChangeRotation(amount)
			
			'rotate child direction of travel
'			b.ChangeDirection(amount)
			b._velocity.Rotate(amount)
			b._acceleration.Rotate(amount)

			'if the child has children, rotate those too (recursively)
			b.RotateChildren(amount)
		Next
	End Method	
	
'#endregion
		
End Type
