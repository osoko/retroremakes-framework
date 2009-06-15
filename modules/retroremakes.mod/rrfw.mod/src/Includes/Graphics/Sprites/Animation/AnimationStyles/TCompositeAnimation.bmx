'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TCompositeAnimation Extends TSpriteAnimation

	Field Lanimations:TList
	Field LfinishedAnimations:TList
	
	Method New()
		Lanimations = New TList
		LfinishedAnimations = New TList
	End Method
	
	Method AddAnimation(animation:TSpriteAnimation)
		Lanimations.AddLast(animation)
	End Method
	
	
	
	Method remove()
		Local animation:TSpriteAnimation
		For animation = EachIn Lanimations
			animation.remove()
			Lanimations.remove(animation)
			animation = Null
		Next
		For animation = EachIn LfinishedAnimations
			animation.remove()
			LfinishedAnimations.remove(animation)
			animation = Null
		Next
	End Method
	
	
	
	Method Reset()
		While LfinishedAnimations.Count() > 0
			Lanimations.AddLast(LfinishedAnimations.RemoveFirst())
		WEnd
		For Local animation:TSpriteAnimation = EachIn Lanimations
			animation.Reset()
		Next
		Super.Reset()
	End Method
	
	Method Update:Int(sprite:TSprite)
		For Local animation:TSpriteAnimation = EachIn Lanimations
			If TSpriteAnimation(animation).Update(sprite)
				Lanimations.Remove(animation)
				LfinishedAnimations.AddLast(animation)
			End If
		Next
		If Lanimations.Count() = 0
			isFinished = True
		End If
		Return Finished()
	End Method
	
End Type
