rem
	bbdoc: Type description
end rem
Type THighScoreTableScreen Extends TScreenBase

	Const NUM_HIGH_SCORES:Int = 5
	Const SCORE_COLOUR_OFFSET:Float = 15.0
	Const SCORE_X_SPACING:Int = 10
	Const SCORE_Y_SPACING:Int = 10

	Field displayFont:TImageFont
	Field displayScores:TFontActor[NUM_HIGH_SCORES]
	Field displayNames:TFontActor[NUM_HIGH_SCORES]
	Field footer:TFontActor
	Field header:TFontActor
	Field headerDisplayFont:TImageFont
	Field highlightScore:Int
	Field highlightScoreColour:TColourGen
	Field highScoreTable:THighScoreTable
	Field scoreColour:TColourGen
		
	Method CreateHighScoreTable()
		highScoreTable = New THighScoreTable.Create("hiscore.dat", 5)
		
		RestoreData DefaultNames
		For Local i:Int = 0 To NUM_HIGH_SCORES - 1
			Local score:Int
			Local name:String
			ReadData score, name
			highScoreTable.AddScore(score, name, 0)
		Next
		
		' add to the registry so other objects can access it if required
		TRegistry.GetInstance().Add("HighScoreTable", highScoreTable)
	End Method
	
	
	

	
	
	
	Method HandleKeyboardMessage(message:TMessage)
		Local data:TKeyboardMessageData = TKeyboardMessageData(message.data)
		Select data.key
			Case KEY_ENTER
				If data.keyHits Then GoBackToTitleScreen()
		End Select
	End Method
	
	
	
	Method MessageListener(message:TMessage)
		Select message.messageId
			Case MSG_KEY
				HandleKeyboardMessage(message)
		End Select
	End Method
	
	
	
	Method New()
		displayFont = rrGetResourceImageFont("resources/ArcadeClassic.ttf", 36)
		headerDisplayFont = rrGetResourceImageFont("resources/ArcadeClassic.ttf", 48)
		highlightScoreColour = rrGetResourceColourGen("resources/FastFire.ini")
		scoreColour = rrGetResourceColourGen("resources/QuickerThrob.ini")
		
		Local screenMidX:Float = TProjectionMatrix.GetInstance().GetWidth() / 2.0
		
		highlightScore = 0

		CreateHighScoreTable()
		
		For Local i:Int = 0 To NUM_HIGH_SCORES - 1
			displayScores[i] = New TFontActor
			displayNames[i] = New TFontActor
			displayScores[i].SetFont(displayFont)
			displayNames[i].SetFont(displayFont)
		Next
		
		SetImageFont(headerDisplayFont)
		
		header = New TFontActor
		header.SetFont(headerDisplayFont)
		header.SetText("High-Score Table")
		header.SetPosition(screenMidX - (TextWidth(header.GetText()) / 2.0), 50.0)
		header.SetVisible(True)
		
		SetImageFont(displayFont)
		
		footer = New TFontActor
		footer.SetFont(displayFont)
		footer.SetText("Press Enter to Continue")
		footer.SetPosition(screenMidX - (TextWidth(footer.GetText()) / 2.0),  ..
			TProjectionMatrix.GetInstance().GetHeight() - displayFont.Height() - 50.0)
		footer.SetVisible(True)
		
	End Method
	

	
	
	
	Method Start()
		TMessageService.GetInstance().SubscribeToChannel(CHANNEL_INPUT, Self)
		UpdateHighScoreTableDisplay()
		theLayerManager.AddRenderObjectToLayerByName(header, "middle")
		theLayerManager.AddRenderObjectToLayerByName(footer, "middle")
	End Method
	
	
	
	Method Stop()
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
		For Local i:Int = 0 To NUM_HIGH_SCORES - 1
			theLayerManager.RemoveRenderObject(displayScores[i])
			theLayerManager.RemoveRenderObject(displayNames[i])
		Next
		theLayerManager.RemoveRenderObject(header)
		theLayerManager.RemoveRenderObject(footer)
		Finished()
	End Method
	
	
	
	Method ToString:String()
		Return "HighScoreTable:" + Super.ToString()
	End Method
	
	

	
	
	
	Method UpdateHighScoreTableDisplay()
		Local screenMidX:Float = TProjectionMatrix.GetInstance().GetWidth() / 2.0
		Local screenMidY:Float = TProjectionMatrix.GetInstance().GetHeight() / 2.0
		
		Local startY:Float = screenMidY - (((displayFont.Height() * NUM_HIGH_SCORES) + (SCORE_Y_SPACING * (NUM_HIGH_SCORES - 1))) / 2.0)
		
		SetImageFont(displayFont)
		
		For Local i:Int = 0 To NUM_HIGH_SCORES - 1
			Local score:THighScoreEntry = highscoreTable.allEntries[i]

			'Local display:String = score.GetScore() + "  " + score.GetPlayerName()
			displayScores[i].SetText(score.GetScore())
			displayScores[i].SetPosition(screenMidX - SCORE_X_SPACING - TextWidth(score.GetScore()), startY)
			displayScores[i].SetVisible(True)
			
			displayNames[i].SetText(score.GetPlayerName())
			displayNames[i].SetPosition(screenMidX + SCORE_X_SPACING, startY)
			displayNames[i].SetVisible(True)
			
			displayScores[i].GetAnimationManager().Remove()
			displayNames[i].GetAnimationManager().Remove()
			
			Local anim:TColourOscillatorAnimation = New TColourOscillatorAnimation
			If i = highlightScore
				anim.SetColourGen(highlightScoreColour)
			Else
				anim.SetColourGen(scoreColour)
				anim.SetOffset(i * SCORE_COLOUR_OFFSET)
			EndIf
			displayScores[i].GetAnimationManager().AddAnimation(anim)
			displayNames[i].GetAnimationManager().AddAnimation(anim)
			
			theLayerManager.AddRenderObjectToLayerByName(displayScores[i], "middle")
			theLayerManager.AddRenderObjectToLayerByName(displayNames[i], "middle")
			
			startY:+displayFont.Height() + SCORE_Y_SPACING
		Next
		
		
	End Method
	
End Type


#DefaultNames
DefData 10000, "Muttley"
DefData 5000, "Wiebo"
DefData 2500, "deps"
DefData 1250, "thalamus"
DefData 625, "Bog"
