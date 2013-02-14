rem
	bbdoc: Type description
end rem
Type RC4Tests Extends TTest 

	Const NUM_TEST_STRINGS:Int = 5

'	Const KEY:String = "0#C\IHdx3g$M=mmWihBkKzS:90QQnoW+HXnjF18+e-IAii17W@+s+JF+=CXJP&Fq"
	
	Field decrypted   :String[]
	Field encrypted   :String[]
	Field testStrings :String[]
	
	Field key:String
	
	Method _setup() {before}
		SeedRnd (MilliSecs())
		
		' Generate a random encryption key
		For Local i:Int = 1 To 255
			key :+ Chr (Rand(0, 1000))
		Next
		
		decrypted   = New String[NUM_TEST_STRINGS]
		encrypted   = New String[NUM_TEST_STRINGS]
		testStrings = New String[NUM_TEST_STRINGS]
		
		testStrings[0] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " ..
			+ "Proin in augue lacinia eros mollis porta. Nunc massa purus, vestibulum " ..
			+ "ac ultrices vestibulum, rhoncus et ligula. Nullam commodo turpis vitae " ..
			+ "lorem pretium sed interdum nunc scelerisque. Fusce ante leo, pellentesque " ..
			+ "et semper mollis, commodo eleifend est. Aliquam condimentum mauris non " ..
			+ "orci elementum in aliquet mauris rutrum. Maecenas nec tincidunt erat. " ..
			+ "Cras sed tortor quis quam accumsan aliquet a consectetur dolor. Sed metus " ..
			+ "risus, faucibus non tempor vitae, tempor at lorem. In sit amet felis non " ..
			+ "orci accumsan lacinia tempus nec velit. Sed eget velit mi, vel viverra ligula."
			
		testStrings[1] = "Vivamus lacinia elementum nunc quis varius. Curabitur imperdiet " ..
			+ "viverra feugiat. Nulla facilisi. Etiam ornare lorem non lorem dapibus id " ..
			+ "imperdiet felis rutrum. Sed at condimentum nulla. Vivamus vehicula, ligula " ..
			+ "id facilisis dignissim, metus velit dapibus tellus, eu viverra risus justo " ..
			+ "commodo enim. Proin tincidunt nisi at velit tincidunt egestas ullamcorper " ..
			+ "massa iaculis. Praesent tempus ullamcorper lectus, et mattis sem convallis " ..
			+ "ac. Aliquam justo ligula, bibendum non placerat a, egestas eu elit. Maecenas " ..
			+ "in dolor dignissim lorem blandit tincidunt. In nunc diam, dignissim eget " ..
			+ "eleifend id, commodo vel massa. Vestibulum facilisis euismod libero vel " ..
			+ "fringilla. Suspendisse lobortis libero id neque aliquam ultricies. Phasellus " ..
			+ "aliquam volutpat cursus."
		
		testStrings[2] = "Class aptent taciti sociosqu ad litora torquent per conubia nostra, " ..
			+ "per inceptos himenaeos. Nulla facilisis vestibulum dui a sollicitudin. Etiam " ..
			+ "vel risus sit amet magna auctor vehicula. Cras suscipit ligula quis massa " ..
			+ "tincidunt lacinia. Proin eget quam non est lacinia pretium ac ut justo. " ..
			+ "Vestibulum vel leo varius lacus accumsan luctus ut vitae diam. Duis in est " ..
			+ "lectus, sit amet eleifend magna. Donec at lectus non mauris gravida faucibus " ..
			+ "a non odio. Vivamus velit purus, vehicula ut tincidunt nec, posuere vel libero."
		
		testStrings[3] = "Duis et venenatis neque. Vestibulum placerat ante at leo molestie " ..
			+ "dapibus. In tempor feugiat arcu tempor lobortis. Lorem ipsum dolor sit amet, " ..
			+ "consectetur adipiscing elit. In eu odio mattis nisl venenatis dapibus vel sit " ..
			+ "amet nunc. Cras porttitor metus sed eros interdum vel venenatis augue auctor. " ..
			+ "Sed aliquam dignissim felis. Sed posuere dui vel elit eleifend feugiat. Nam " ..
			+ "fermentum ornare nisl et eleifend. Nullam id sem sem."
		
		testStrings[4] = "Morbi quis ipsum eget nisi ultricies dictum et at ante. Nulla non " ..
			+ "ipsum sed risus condimentum tempor. Nunc nec neque felis. Aliquam erat volutpat. " ..
			+ "Nullam aliquam blandit fringilla. Aliquam commodo dolor sit amet massa " ..
			+ "sollicitudin feugiat. Etiam venenatis tempus eros et imperdiet."
			
		For Local i:Int = 0 Until NUM_TEST_STRINGS
			encrypted[i] = RC4 (testStrings[i], key)
			decrypted[i] = RC4 (encrypted[i],   key)
		Next			
	End Method
	
	
	Method StringDoesNotMatchAfterEncrypt() {test}
		For Local i:Int = 0 Until NUM_TEST_STRINGS
			' String compare returns non-zero (therefore True) if compare fails,
			' which is what we want to see.
			'
			assertTrue ((testStrings[i].Compare (encrypted[i])), "Encryption failed")
		Next
	End Method

		
	Method StringDoesMatchAfterDecrypt() {test}
		For Local i:Int = 0 Until NUM_TEST_STRINGS
			assertEquals (decrypted[i], testStrings[i], "Decryption failed")			  
		Next			
	End Method
		
End Type
