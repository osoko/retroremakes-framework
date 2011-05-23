Rem
'
' Copyright (c) 2007-2011 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

Rem
bbdoc: Type representing a player's score
about: This Type tracks both a player's score and the length of time they
have played the game. It also applies any specified multiplier to any
scores added if required and can optionally track a separate display score
which can accumulate slowly to match the actual score. This is useful for
display purposes where you may want the display score to update slower than
the actual score.
EndRem
Type TScore

	' Default maximum value the multiplier can reach
	Const DEFAULT_MAX_MULTIPLIER:Int = 9
	
	' current display score
	Field _displayScore:Long
	
	' value by which the display score is incremented until it reaches the
	' actual score. A value of 0 means that the display score will always
	' exactly match the actual score after the Update() method has been
	' called.
	Field _displayScoreIncrement:Int = 0
	
	' The time in millisecs that the score was last updated. Used to calculate
	' played time.
	Field _lastUpdateTime:Int
	
	' The maximum value the multiplier can reach
	Field _maxMultiplier:Int = DEFAULT_MAX_MULTIPLIER
	
	' Current multiplier value
	Field _multiplier:Int
	
	' Boolean holding whether the score is paused or not
	Field _paused:Int
	
	' The actual score
	Field _score:Long
	
	' The length of time played in milliseconds
	Field _timePlayed:Int

	
	Rem
		bbdoc: Create a new TScore instance
		about: This constructor creates a new TScore instance.
		returns: #TScore
	EndRem
	Function Create:TScore(displayIncrement:Int = 0, maxMultiplier:Int = 9)
		Local n:TScore = New TScore
		n.SetMaxMultiplier(maxMultiplier)
		n.SetDisplayScoreIncrement(displayIncrement)
		Return n
	EndFunction
	
	

	Rem
		bbdoc: Add a value to the score
		about: Adds the supplied value to the score multiplied by the current
		multiplier value.
	EndRem
	Method Add( value:Int )
		SetScore(GetScore() + (value * GetMultiplier()))
	EndMethod

	

	Rem
		bbdoc: Decreases the multiplier by 1.
		about: Multiplier cannot go below a value of 1.
	EndRem
	Method DecreaseMultiplier()
		Local multiplier:Int = GetMultiplier()
		If multiplier > 1
			SetMultiplier(multiplier - 1)
		EndIf
	EndMethod
	
	
		
	Rem
		bbdoc: Gets the current display score
		about: The display score may or may not be the current actual score. If
		the Display Score Increment is set to a non-zero value, the display score
		will step up to the actual score by that amount every time the Update()
		method is called until it reaches the current score.
	EndRem
	Method GetDisplayScore:Long()
		Return _displayScore
	EndMethod
	
	
	
	Rem
		bbdoc: Gets the current display score increment value
		about: The display score may or may not be the current actual score. If
		the Display Score Increment is set to a non-zero value, the display score
		will step up to the actual score by that amount every time the Update()
		method is called until it reaches the current score.
	EndRem
	Method GetDisplayScoreIncrement:Int()
		Return _displayScoreIncrement
	End Method
	
	
	
	Rem
		bbdoc: Gets the last update time in milliseconds
	EndRem
	Method GetLastUpdateTime:Int()
		Return _lastUpdateTime
	End Method
	
	
	
	Rem
		bbdoc: Gets the maximum multipier value
	EndRem
	Method GetMaxMultiplier:Int()
		Return _maxMultiplier
	End Method
	
	
	
	Rem
		bbdoc: Gets the current multiplier value
	EndRem
	Method GetMultiplier:Int()
		Return _multiplier
	EndMethod
	
	
					
	Rem
		bbdoc: Get the current score value
		about: Returns the current score.
	EndRem
	Method GetScore:Long()
		Return _score
	EndMethod
	
	
	
	Rem
		bbdoc: Returns the time played in milliseconds
		about: Time played is the length of time a score was active (not paused)
		and being updated. This can be used to measure the length of a game.
	EndRem
	Method GetTimePlayed:Int()
		Return _timePlayed
	EndMethod
	
	
		
	Rem
		bbdoc: Increases the multiplier by 1
		about: Multiplier cannot exceed the maximum multiplier value set
	EndRem
	Method IncreaseMultiplier()
		Local multiplier:Int = GetMultiplier()
		If multiplier < GetMaxMultiplier()
			SetMultiplier(multiplier + 1)
		EndIf
	EndMethod
	
	
	
	Rem
		bbdoc: This method is deprecated and may be removed in future versions
		about: Use the Initialise method instead.
	EndRem
	Method Init()
		DebugLog("The TScore.Init() method is deprecated and may be removed in future versions, please use the TScore.Initialise() method instead.")
		Initialise()
	EndMethod
	
	
	
	Rem
		bbdoc: Initialise the score
		about: Resets the score, multiplier and played time to zero. This should be
		called when the player starts playing a game to ensure that the played time
		value is accurate.
	EndRem
	Method Initialise()
		SetScore(0)
		SetDisplayScore(0)
		SetTimePlayed(0)
		SetMultiplier(1)
		SetLastUpdateTime(MilliSecs())
		SetPaused(False)
	End Method
	
	
	
	Rem
		bbdoc: Is the score paused or not?
		about: Returns True if the score is paused, otherwise returns False.
	EndRem
	Method IsPaused:Int()
		Return _paused
	End Method
	
	
						
	Rem
		bboc: Default constructor
		about: This adds the new TScore instance to the TScoreSerivce so
		it will be updated automatically each logic update loop.
	EndRem
	Method New()
		TScoreService.GetInstance().AddScore(Self)
	End Method
	
	
	
	Rem
		bbdoc: This method is deprecated and may be removed in future versions
		about: Use the SetPaused() method instead.
	EndRem
	Method Pause()
		DebugLog("The TScore.Pause() method is deprecated and may be removed in future versions, please use the TScore.SetPaused() method instead.")
		SetPaused(True)
	EndMethod
	
	
	
	Rem
		bbdoc: Set the display score
		about: Sets the display score to the specified value.
	EndRem
	Method SetDisplayScore(value:Int)
		_displayScore = value
	End Method
	
	
			
	Rem
		bbdoc: Sets the display score increment
		about: The display score may or may not be the current actual score. If
		the Display Score Increment is set to a non-zero positive value, the display
		score will step up to the actual score by that amount every time the Update()
		method is called until it reaches the current score.
	EndRem
	Method SetDisplayScoreIncrement(value:Int)
		If value >= 0
			_displayScoreIncrement = value
		EndIf
	End Method
	
	
	
	Rem
		bbdoc: Sets the last update time
		about: Value is in milliseconds
	EndRem	
	Method SetLastUpdateTime(value:Int)
		_lastUpdateTime = value
	End Method
	
	
	
	Rem
		bbdoc: Sets the maximum multiplier value
		about: Maximum can be no lower than 1
	EndRem
	Method SetMaxMultiplier(value:Int)
		If value > 0
			_maxMultiplier = value
		EndIf
	End Method
	
	
	
	Rem
		bbdoc: Sets the current multiplier value
		about: The multiplier is constrained to a value >= 1 and <= the maximum
		multiplier value. Any attempt to set the multiplier to an illegal value
		will be silently ignored.
	EndRem
	Method SetMultiplier(value:Int)
		If value < 1 Or value > GetMaxMultiplier() Then Return
		_multiplier = value
	EndMethod
	
	
	
	Rem
		bbdoc: Set whether the score is paused or not
		about: Calling this method with a value of True will pause the score,
		using a value of False with unpause it.
		When paused the score will not be updated by the Update()
		method, and the time played counter is frozen. This allows you
		to accurately measure the actual time spent playing the game.
	EndRem
	Method SetPaused(value:Int)
		If value
			_paused = True
		Else
			If IsPaused()
				_paused = False
				_lastUpdateTime = MilliSecs()
			End If
		End If
	End Method
	
	
	
	Rem
		bbdoc: Sets the score to the specified value
		about: This bypasses the multiplier calculator and sets the score to
		exactly the value specified
	EndRem
	Method SetScore(value:Long)
		_score = value
	End Method
	
	

	Rem
		bbdoc: Sets the time played in milliseconds
	EndRem
	Method SetTimePlayed(value:Int)
		_timePlayed = value
	End Method
	
	
	
	Rem
		bbdoc: This method is deprecated and may be removed in future versions
		about: Use the SetPaused() method instead.
	EndRem		
	Method Unpause()
		DebugLog("The TScore.Unpause() method is deprecated and may be removed in future versions, please use the TScore.SetPaused() method instead.")
		SetPaused(False)
	EndMethod	

	
	
	Rem
		bbdoc: Update the score
		about: Updates both the display score and time played. Returns without doing
		anything if the score has been paused.
	EndRem
	Method Update()
		If IsPaused() Then Return
		
		Local displayScore:Long = GetDisplayScore()
		Local displayScoreIncrement:Int = GetDisplayScoreIncrement()
		Local score:Long = GetScore()
		
		If displayScore <> score
			If displayScoreIncrement = 0
				SetDisplayScore(score)
			Else
				If (score - displayScore) < displayScoreIncrement
					SetDisplayScore(score)
				Else
					SetDisplayScore(displayScore + displayScoreIncrement)
				EndIf
			EndIf
		EndIf
		
		Local lastUpdateTime:Int = GetLastUpdateTime()
		Local now:Int = MilliSecs()
		SetTimePlayed(GetTimePlayed() + (now - lastUpdateTime))
		SetLastUpdateTime(now)
	EndMethod
	
EndType