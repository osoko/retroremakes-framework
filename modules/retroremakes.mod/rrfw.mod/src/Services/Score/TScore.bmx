Type TScore

	Field displayScore:Long
	Field displayScoreIncrement:Int = 0		'0 = update immediately, >0 = increment by that each frame
	Field ltime:Int
	Field maxMultiplier:Int = 9
	Field multiplier:Int
	Field paused:Int
	Field timePlayed:Int
	Field score:Long

	Method New()
		TScoreService.GetInstance().AddScore(Self)
	End Method
	
	Function Create:TScore( displayInc:Int = 0, maxMulti:Int = 9 )
		Local n:TScore = New TScore
		n.SetMaxMultiplier( maxMulti )
		Return n
	EndFunction

	Method Add( value:Int )
		score :+ ( value * multiplier )
	EndMethod

	Method DecreaseMultiplier()
		If multiplier = 1 Then Return
		multiplier :- 1
	EndMethod
	
	Method GetDisplayScore:Long()
		Return displayScore
	EndMethod

	Method GetDisplayScoreIncrement:Int()
		Return displayScoreIncrement
	End Method
	
	Method GetMaxMultiplier:Int()
		Return maxMultiplier
	End Method

	Method GetMultiplier:Int()
		Return multiplier
	EndMethod

	Method GetScore:Long()
		Return score
	EndMethod
	
	Method GetTimePlayed:Int()
		Return timePlayed
	EndMethod

	Method IncreaseMultiplier()
		If multiplier = maxMultiplier Then Return
		multiplier :+ 1
	EndMethod
	
	Method Init()
		score = 0
		displayScore = 0
		timePlayed = 0
		multiplier = 1
		ltime = MilliSecs()
		paused = False
	EndMethod

	Method Pause()
		paused = True
	EndMethod

	Method SetDisplayScoreIncrement( value:Int )
		displayScoreIncrement = value	
	End Method
	
	Method SetMaxMultiplier( value:Int )
		maxMultiplier = value
	End Method

	Method SetMultiplier( value:Int )
		If value < 1 Or value > maxMultiplier Then Return
		multiplier = value
	EndMethod
	
	Method Unpause()
		paused = False
		ltime = MilliSecs()
	EndMethod
	
	Method Update()
		If paused Then Return
		If displayScore <> score
			If displayScoreIncrement = 0
				displayScore = score
			Else
				If score - displayScore < displayScoreIncrement
					displayScore = score
				Else
					displayScore :+ displayScoreIncrement
				EndIf	
			EndIf
		EndIf
		Local ctime:Int = MilliSecs()
		timePlayed :+ ( ctime - ltime )
		ltime = ctime
	EndMethod
	
EndType