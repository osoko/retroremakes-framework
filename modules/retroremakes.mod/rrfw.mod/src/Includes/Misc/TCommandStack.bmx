Type TCommandStack
	Field LUndoCommands:TStack = New TStack
	Field LRedoCommands:TStack = New TStack
	Field undoCommandCountAtLastSave:Int = 0
	
	rem
		bbdoc: Adds the command to the command stack (which may involve losing Redo or even
		potentially Undo information) and issues the command.
		returns:
	endrem
	Method AddCommand(command:TCommand)
		If command.Execute()

			If Not command.CanBeUndone()
				'This command cannot be undone, so clear the stack  - we don't need it any more
				LUndoCommands.Clear()
				LRedoCommands.Clear()
				undoCommandCountAtLastSave = -1 ' We can't undo the get to the last saved state
				' No point pushing the command on the stack - we can't undo it!
			Else
				' We can't redo anything having just done something
				LRedoCommands.Clear()
				
				If undoCommandCountAtLastSave > LUndoCommands.Count()
					undoCommandCountAtLastSave = -1 ' We can't undo to get to the last saved state
				End If
				
				Rem
				Attempts to merge the command on the tope of the stack.
				EndRem
				If LUndoCommands.Count() = 0 Or Not TCommand(LUndoCommands.Peek()).Merge(command)
					LUndoCommands.Push(command)
				EndIf
			End If
		End If
	End Method

	Method CanRedo:Int()
		Return LRedoCommands.Count() > 0
	End Method
	
	Method CanUndo:Int()
		Return LUndoCommands.Count() > 0
	End Method
	
	Method IsDirty:Int()
		Return undoCommandCountAtLastSave <> LUndoCommands.Count()
	End Method
	
	Method ProgressSaved()
		undoCommandCountAtLastSave = LUndoCommands.Count()
	End Method

	Method Redo()
		If CanRedo()
			Local command:TCommand = TCommand(LRedoCommands.Pop())
			command.Execute()
			LUndoCommands.Push(command)
		End If
	End Method
			
	Method Undo()
		If CanUndo()
			Local command:TCommand = TCommand(LUndoCommands.Pop())
			command.Unexecute()
			LRedoCommands.Push(command)
		End If
	End Method

End Type