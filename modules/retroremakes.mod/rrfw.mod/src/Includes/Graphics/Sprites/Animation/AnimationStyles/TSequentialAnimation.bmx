'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSequentialAnimation Extends TSpriteAnimation

	Field animations:TList
	Field finishedAnimations:TList
	
	
	
	Method New()
		animations = New TList
		finishedAnimations = New TList
	End Method
	
	
	
	Method AddAnimation(animation:TSpriteAnimation)
		animations.AddLast(animation)
	End Method
	
	

	Method remove()
		Local animation:TSpriteAnimation
		For animation = EachIn animations
			animation.remove()
			animations.remove(animation)
			animation = Null
		Next
		For animation = EachIn finishedAnimations
			animation.remove()
			finishedAnimations.remove(animation)
			animation = Null
		Next		
	End Method
	
	
			
	Method Reset()
		'move the remaining animations to the finished list
		While animations.Count() > 0
			finishedAnimations.AddLast(animations.RemoveFirst())
		Wend
		animations.Clear()
		
		'repopulate animation list and reset all animations
		While finishedAnimations.Count() > 0
			animations.AddLast(finishedAnimations.RemoveFirst())
			TSpriteAnimation(animations.Last()).Reset()
		Wend
		finishedAnimations.Clear()
		Super.Reset()
	End Method
	
	
	
	Method Update:Int(sprite:TSprite)
		If animations.Count() > 0
			If TSpriteAnimation(animations.First()).Update(sprite)
				'Animation has finished so move it to the finished list
				finishedAnimations.AddLast(animations.RemoveFirst())
				If animations.Count() = 0
					isFinished = True
				End If
			EndIf
		Else
			isFinished = True
		EndIf
		Return Finished()
	End Method

End Type
