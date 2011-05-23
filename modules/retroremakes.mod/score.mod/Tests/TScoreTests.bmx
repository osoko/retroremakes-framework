' Unit Tests for the TScore Type
Type TScoreTests Extends TTest
	
	Field _score:TScore
	
	Method _setup() {before}
		_score = New TScore
		_score.Initialise()
	End Method
	
	Method _teardown() {after}
	End Method

	Method CanCreateNewScore() {test}
		Local score:TScore = TScore.Create()
		assertNotNull(score)
	End Method
	
	Method CreatedScoreGetsCorrectDefaultValues() {test}
		Local score:TScore = TScore.Create()
		assertEqualsI(0, score.GetDisplayScoreIncrement())
		assertEqualsI(9, score.GetMaxMultiplier())
	End Method
	
	Method CreatedScoreGetsCorrectCustomValues() {test}
		Local score:TScore = TScore.Create(100, 13)
		assertEqualsI(100, score.GetDisplayScoreIncrement())
		assertEqualsI(13, score.GetMaxMultiplier())
	End Method
	
	Method CanGetScore() {test}
		_score.SetScore(1000:Long)
		assertEqualsL(1000:Long, _score.GetScore())
	End Method
	
	Method CanSetScore() {test}
		_score.SetScore(64738:Long)
		assertEqualsL(64738:Long, _score.GetScore())
	End Method
	
	Method CanGetDisplayScore() {test}
		_score.Add(49152)
		_score.Update()
		
		assertEqualsI(49152, _score.GetDisplayScore())
	End Method
	
	Method DisplayScoreOnlyChangedByUpdateMethod() {test}
		_score.Add(54624)
		
		assertEqualsI(0, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(54624, _score.GetDisplayScore())
	End Method
	
	Method CanInitialiseScore() {test}
		_score.SetScore(23:Long)
		_score.SetMultiplier(5)
		_score.Add(54)
		_score.Update()
		_score.SetPaused(True)
		
		_score.Initialise()
		
		assertEqualsL(0:Long, _score.GetScore())
		assertEqualsL(0:Long, _score.GetDisplayScore())
		assertEqualsI(0, _score.GetTimePlayed())
		assertEqualsI(1, _score.GetMultiplier())
		assertFalse(_score.IsPaused())
	EndMethod
	
	Method CanAddToScore() {test}
		assertEqualsI(0, _score.GetScore())
		_score.Add(27)
		assertEqualsI(27, _score.GetScore())
	End Method
	
	Method MultiplierAppliedCorrectly() {test}
		_score.SetMultiplier(3)
		_score.Add(3)
		assertEqualsL(9:Long, _score.GetScore())
		_score.SetMultiplier(5)
		_score.Add(17)
		assertEqualsL(94:Long, _score.GetScore())
	End Method
	
	Method CanGetMaxMultiplier() {test}
		_score.SetMaxMultiplier(9)
		assertEqualsI(9, _score.GetMaxMultiplier())
	End Method
	
	Method CanSetMaxMultiplier() {test}
		_score.SetMaxMultiplier(17)
		assertEqualsI(17, _score.GetMaxMultiplier())
	End Method
	
	Method CanGetMultiplier() {test}
		assertEqualsI(1, _score.GetMultiplier())
	End Method
	
	Method CanSetMultiplier() {test}
		_score.SetMultiplier(1)
		assertEqualsI(1, _score.GetMultiplier())
		_score.SetMultiplier(4)
		assertEqualsI(4, _score.GetMultiplier())
	End Method
	
	Method CannotSetIllegalMultiplierValue() {test}
		_score.SetMaxMultiplier(7)
		_score.SetMultiplier(5)
		assertEqualsI(5, _score.GetMultiplier())
		_score.SetMultiplier(99)
		assertEqualsI(5, _score.GetMultiplier())
		_score.SetMultiplier(8)
		assertEqualsI(5, _score.GetMultiplier())
		_score.SetMultiplier(0)
		assertEqualsI(5, _score.GetMultiplier())
		_score.SetMultiplier(-1)
		assertEqualsI(5, _score.GetMultiplier())
	End Method
	
	Method CanIncreaseMultiplier() {test}
		assertEqualsI(1, _score.GetMultiplier())
		_score.IncreaseMultiplier()
		assertEqualsI(2, _score.GetMultiplier())
	End Method
	
	Method CanDecreaseMultiplier() {test}
		_score.SetMultiplier(3)
		assertEqualsI(3, _score.GetMultiplier())
		_score.DecreaseMultiplier()
		assertEqualsI(2, _score.GetMultiplier())
		_score.DecreaseMultiplier()
		assertEqualsI(1, _score.GetMultiplier())
	End Method
	
	Method CannotIncreaseMultiplierPastMaximum() {test}
		_score.SetMultiplier(9)
		assertEqualsI(9, _score.GetMultiplier())
		_score.IncreaseMultiplier()
		assertEqualsI(9, _score.GetMultiplier())
	End Method
	
	Method CannotDecreaseMultiplierBelowOne() {test}
		_score.SetMultiplier(1)
		assertEqualsI(1, _score.GetMultiplier())
		_score.DecreaseMultiplier()
		assertEqualsI(1, _score.GetMultiplier())
	End Method
	
	Method CanGetDisplayScoreIncrement() {test}
		assertEqualsI(0, _score.GetDisplayScoreIncrement())
	End Method
	
	Method CanSetDisplayScoreIncrement() {test}
		_score.SetDisplayScoreIncrement(10)
		assertEqualsI(10, _score.GetDisplayScoreIncrement())
	End Method
	
	Method CannotSetNegativeDisplayScoreIncrement() {test}
		assertEqualsI(0, _score.GetDisplayScoreIncrement())
		_score.SetDisplayScoreIncrement(-10)
		assertEqualsI(0, _score.GetDisplayScoreIncrement())
	End Method
	
	Method CanPauseScore() {test}
		_score.SetPaused(True)
		assertTrue(_score.IsPaused())
	End Method
	
	Method CanUnpauseScore() {test}
		_score.SetPaused(True)
		assertTrue(_score.IsPaused())
		_score.SetPaused(False)
		assertFalse(_score.IsPaused())
	End Method
	
	Method CanGetTimePlayed() {test}
		_score.Initialise()
		assertEqualsI(0, _score.GetTimePlayed())
	End Method
	
	Method TimePlayedIsUpdated() {test}
		_score.Initialise()
		assertEqualsI(0, _score.GetTimePlayed())
		Sleep(1)
		_score.Update()
		Local t:Int = _score.GetTimePlayed()
		assertTrue(t > 0)
		Sleep(1)
		_score.Update()
		assertTrue(_score.GetTimePlayed() > t)
	End Method
	
	Method DisplayScoreIsUpdated() {test}
		_score.Initialise()
		_score.SetDisplayScoreIncrement(100)
		_score.Add(550)
		assertEqualsI(0, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(100, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(200, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(300, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(400, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(500, _score.GetDisplayScore())
		_score.Update()
		assertEqualsI(550, _score.GetDisplayScore())
		_score.Update()
	End Method
	
	Method CanSetDisplayScore() {test}
		_score.SetDisplayScore(1000)
		assertEqualsI(1000, _score.GetDisplayScore())
	End Method
	
	Method CanOnlySetPositiveMaximumMultiplier() {test}
		_score.SetMaxMultiplier(7)
		assertEqualsI(7, _score.GetMaxMultiplier())
		_score.SetMaxMultiplier(-3)
		assertEqualsI(7, _score.GetMaxMultiplier())
		_score.SetMaxMultiplier(0)
		assertEqualsI(7, _score.GetMaxMultiplier())
	End Method
	
End Type
