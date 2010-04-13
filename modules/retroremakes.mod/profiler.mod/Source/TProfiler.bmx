rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Rem
'
' This code is based on teamonkey's Inline Profiler for BlitzMax v0.1
' Copyright (c) 2005 James Arthur <teamonkey@gmail.com>
'	
End Rem

Type TProfiler

	Global instance:TProfiler
	
	Const DEFAULT_DEBUG_PROFILER_ENABLED:String = "false"
	Const DEFAULT_DEBUG_PROFILER_FILENAME:String = "profiler.txt"
	
	Field Lresults:TList = CreateList()
	Field Lsamples:TList = CreateList()
	
	Field _filename:String
'	Field last_t:Double
'	Field dt:Double
	
'	Field min_interval:Double = 1000.0	'1 second
	
	Field _enabled:Int
'	Field profilerShow:Int
	
'	Field font:TImageFont
	
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Initialise()
	EndMethod

	Function Create:TProfiler()
		Return TProfiler.GetInstance()		
	End Function
	
	Function GetInstance:TProfiler()
		If Not instance
			Return New TProfiler	
		Else
			Return instance
		EndIf
	EndFunction
'#End Region 	



	Method Initialise()
		_enabled = rrGetBoolVariable("DEBUG_PROFILER_ENABLED", DEFAULT_DEBUG_PROFILER_ENABLED, "Engine")
		_filename = rrGetStringVariable("DEBUG_PROFILER_FILENAME", DEFAULT_DEBUG_PROFILER_FILENAME, "Engine")
	End Method
		
	
		
	Method CalculateResults()
	
		If Not _enabled Then Return
		
		ClearList(Lresults)
		
		' Put all the results in a list, with child Lsamples associated with
		' their parent
		Local depth:Int = 0
		While depth <= MaxSampleDepth()
			For Local sample:TProfilerSample = EachIn Lsamples

				If sample.level = depth
					Local result:TProfilerResult = New TProfilerResult
					result.FromSample(sample)
					
					If depth = 0
						' Just shove level 0 objects in the list, no need
						' to do anything else
						If result.level = 0
							result.link = ListAddLast(Lresults, result)
						 End If
					Else
						' Insert the results in the list after their respective
						' parents
						If result.level = depth
							For Local i:TProfilerResult = EachIn Lresults
								If result.parent_name = i.name
									result.link = Lresults.InsertAfterLink( result, i.link)
								End If
							Next
						End If						
					EndIf
				EndIf
			Next
			depth:+1
		Wend

		WriteResultsToFile()
	End Method
	
	
	
	Method WriteResultsToFile()
	
		If Not _enabled Then Return
		
		Local file:TStream = WriteStream(_filename)
		
		file.WriteLine ("              Profile Name              | min/msec | max/msec | avg/msec | calls ")
		file.WriteLine ("----------------------------------------+----------+----------+----------+-------")
		
		For Local result:TProfilerResult = EachIn Lresults
			If result.run_count > 0
				Local str:String
				str = LSet(RSet(result.name, result.name.length + result.level), 39)
				str:+" | "
				str:+RSet(Left(String.FromDouble(result.min_t), 8), 8)
				str:+" | "
				str:+RSet(Left(String.FromDouble(result.max_t), 8), 8)
				str:+" | "
				str:+RSet(Left(String.FromDouble(result.avg_t), 8), 8)
				str:+" | "
				str:+result.run_count
				
				file.WriteLine (str)
			EndIf
		Next
		
		file.Close()
	End Method

	
	Method CreateSample:TProfilerSample(name_in:String)
		Local tps:TProfilerSample = New TProfilerSample
		tps.name = name_in
		tps.link = ListAddLast(Lsamples, tps)
		TLogger.getInstance().LogInfo("[" + toString() + "] Sample created: " + tps.name)
		Return tps
	End Method

	
	Method ResetProfiler()
		ClearList(Lsamples)
	End Method	

	
	Method MaxSampleDepth:Int()
		Local maxDepth:Int = 0
		For Local i:TProfilerSample = EachIn Lsamples
			If i.level > maxDepth Then maxDepth = i.level
		Next
		Return maxDepth
	End Method

	Method Enable()
		_enabled = True
	End Method
	
	Method Disable()
		_enabled = False
	End Method
			
End Type



Function rrCreateProfilerSample:TProfilerSample(name:String)
	Return TProfiler.GetInstance().CreateSample(name)
End Function

Function rrDeleteProfilerSample(sample:TProfilerSample)
	TProfilerSample.DeleteSample(sample)
End Function

Function rrStartProfilerSample(sample:TProfilerSample)
	sample.Start()
End Function

Function rrStopProfilerSample(sample:TProfilerSample = Null)
	If (Not sample) Then sample = TProfilerSample.last_sample
	sample.Stop()
End Function

Function rrEnableProfiler()
	TProfiler.GetInstance().Enable()
End Function

Function rrDisableProfiler()
	TProfiler.GetInstance().Disable()
End Function

