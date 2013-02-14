' Unit Tests for the TScore Type
Type TScoreTests Extends TTest
	
	Field score:TScore
	
	Method _setup() {before}
		score = New TScore
		score.Initialise()
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
		score.SetScore(1000:Long)
		assertEqualsL(1000:Long, score.GetScore())
	End Method
	
	Method CanSetScore() {test}
		score.SetScore(64738:Long)
		assertEqualsL(64738:Long, score.GetScore())
	End Method
	
	Method CanGetDisplayScore() {test}
		score.Add(49152)
		score.Update()
		
		assertEqualsI(49152, score.GetDisplayScore())
	End Method
	
	Method DisplayScoreOnlyChangedByUpdateMethod() {test}
		score.Add(54624)
		
		assertEqualsI(0, score.GetDisplayScore())
		score.Update()
		assertEqualsI(54624, score.GetDisplayScore())
	End Method
	
	Method CanInitialiseScore() {test}
		score.SetScore(23:Long)
		score.SetMultiplier(5)
		score.Add(54)
		score.Update()
		score.SetPaused(True)
		
		score.Initialise()
		
		assertEqualsL(0:Long, score.GetScore())
		assertEqualsL(0:Long, score.GetDisplayScore())
		assertEqualsI(0, score.GetTimePlayed())
		assertEqualsI(1, score.GetMultiplier())
		assertFalse(score.IsPaused())
	EndMethod
	
	Method CanAddToScore() {test}
		assertEqualsI(0, score.GetScore())
		score.Add(27)
		assertEqualsI(27, score.GetScore())
	End Method
	
	Method MultiplierAppliedCorrectly() {test}
		score.SetMultiplier(3)
		score.Add(3)
		assertEqualsL(9:Long, score.GetScore())
		score.SetMultiplier(5)
		score.Add(17)
		assertEqualsL(94:Long, score.GetScore())
	End Method
	
	Method CanGetMaxMultiplier() {test}
		score.SetMaxMultiplier(9)
		assertEqualsI(9, score.GetMaxMultiplier())
	End Method
	
	Method CanSetMaxMultiplier() {test}
		score.SetMaxMultiplier(17)
		assertEqualsI(17, score.GetMaxMultiplier())
	End Method
	
	Method CanGetMultiplier() {test}
		assertEqualsI(1, score.GetMultiplier())
	End Method
	
	Method CanSetMultiplier() {test}
		score.SetMultiplier(1)
		assertEqualsI(1, score.GetMultiplier())
		score.SetMultiplier(4)
		assertEqualsI(4, score.GetMultiplier())
	End Method
	
	Method CannotSetIllegalMultiplierValue() {test}
		score.SetMaxMultiplier(7)
		score.SetMultiplier(5)
		assertEqualsI(5, score.GetMultiplier())
		score.SetMultiplier(99)
		assertEqualsI(5, score.GetMultiplier())
		score.SetMultiplier(8)
		assertEqualsI(5, score.GetMultiplier())
		score.SetMultiplier(0)
		assertEqualsI(5, score.GetMultiplier())
		score.SetMultiplier(-1)
		assertEqualsI(5, score.GetMultiplier())
	End Method
	
	Method CanIncreaseMultiplier() {test}
		assertEqualsI(1, score.GetMultiplier())
		score.IncreaseMultiplier()
		assertEqualsI(2, score.GetMultiplier())
	End Method
	
	Method CanDecreaseMultiplier() {test}
		score.SetMultiplier(3)
		assertEqualsI(3, score.GetMultiplier())
		score.DecreaseMultiplier()
		assertEqualsI(2, score.GetMultiplier())
		score.DecreaseMultiplier()
		assertEqualsI(1, score.GetMultiplier())
	End Method
	
	Method CannotIncreaseMultiplierPastMaximum() {test}
		score.SetMultiplier(9)
		assertEqualsI(9, score.GetMultiplier())
		score.IncreaseMultiplier()
		assertEqualsI(9, score.GetMultiplier())
	End Method
	
	Method CannotDecreaseMultiplierBelowOne() {test}
		score.SetMultiplier(1)
		assertEqualsI(1, score.GetMultiplier())
		score.DecreaseMultiplier()
		assertEqualsI(1, score.GetMultiplier())
	End Method
	
	Method CanGetDisplayScoreIncrement() {test}
		assertEqualsI(0, score.GetDisplayScoreIncrement())
	End Method
	
	Method CanSetDisplayScoreIncrement() {test}
		score.SetDisplayScoreIncrement(10)
		assertEqualsI(10, score.GetDisplayScoreIncrement())
	End Method
	
	Method CannotSetNegativeDisplayScoreIncrement() {test}
		assertEqualsI(0, score.GetDisplayScoreIncrement())
		score.SetDisplayScoreIncrement(-10)
		assertEqualsI(0, score.GetDisplayScoreIncrement())
	End Method
	
	Method CanPauseScore() {test}
		score.SetPaused(True)
		assertTrue(score.IsPaused())
	End Method
	
	Method CanUnpauseScore() {test}
		score.SetPaused(True)
		assertTrue(score.IsPaused())
		score.SetPaused(False)
		assertFalse(score.IsPaused())
	End Method
	
	Method CanGetTimePlayed() {test}
		score.Initialise()
		assertEqualsI(0, score.GetTimePlayed())
	End Method
	
	Method TimePlayedIsUpdated() {test}
		score.Initialise()
		assertEqualsI(0, score.GetTimePlayed())
		Sleep(1)
		score.Update()
		Local t:Int = score.GetTimePlayed()
		assertTrue(t > 0)
		Sleep(1)
		score.Update()
		assertTrue(score.GetTimePlayed() > t)
	End Method
	
	Method DisplayScoreIsUpdated() {test}
		score.Initialise()
		score.SetDisplayScoreIncrement(100)
		score.Add(550)
		assertEqualsI(0, score.GetDisplayScore())
		score.Update()
		assertEqualsI(100, score.GetDisplayScore())
		score.Update()
		assertEqualsI(200, score.GetDisplayScore())
		score.Update()
		assertEqualsI(300, score.GetDisplayScore())
		score.Update()
		assertEqualsI(400, score.GetDisplayScore())
		score.Update()
		assertEqualsI(500, score.GetDisplayScore())
		score.Update()
		assertEqualsI(550, score.GetDisplayScore())
		score.Update()
	End Method
	
	Method CanSetDisplayScore() {test}
		score.SetDisplayScore(1000)
		assertEqualsI(1000, score.GetDisplayScore())
	End Method
	
	Method CanOnlySetPositiveMaximumMultiplier() {test}
		score.SetMaxMultiplier(7)
		assertEqualsI(7, score.GetMaxMultiplier())
		score.SetMaxMultiplier(-3)
		assertEqualsI(7, score.GetMaxMultiplier())
		score.SetMaxMultiplier(0)
		assertEqualsI(7, score.GetMaxMultiplier())
	End Method
	
End Type
