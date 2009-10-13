rem
'
' Copyright (c) 2007-2009 Paul Maskelyne <muttley@muttleyville.org>.
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

Type TProfiler Extends TGameService

	Global instance:TProfiler
	
	Const DEFAULT_DEBUG_PROFILER_ENABLED:String = "false"
	Const DEFAULT_DEBUG_PROFILER_SHOW:String = "false"
	
	Field Lresults:TList = CreateList()
	Field Lsamples:TList = CreateList()
	
	Field last_t:Double
	Field dt:Double
	
	Field min_interval:Double = 1000.0	'1 second
	
	Field profilerEnabled:Int
	Field profilerShow:Int
	
	Field font:TImageFont
	
'#Region Constructors
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
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
		SetName("Profiler")
		updatePriority = 1000
		renderPriority = 1000
		
		Super.Initialise()
	End Method

	Method Shutdown()
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method

	Method Start()
		profilerEnabled = rrGetBoolVariable("DEBUG_PROFILER_ENABLED", DEFAULT_DEBUG_PROFILER_ENABLED, "Engine")
		profilerShow = rrGetBoolVariable("DEBUG_PROFILER_SHOW", DEFAULT_DEBUG_PROFILER_SHOW, "Engine")
		engineInstance = TGameEngine.GetInstance()
	End Method
			
	Method DebugUpdate()
	
		If Not (profilerEnabled And engineInstance.debugEnabled) Then Return
		
		Local now:Double = rrMillisecs()
				
		If (now - last_t < min_interval) Then Return

		dt = now-last_t
		last_t = now
		
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

	End Method
	
	
	Method DebugRender()
		If Not (profilerEnabled And engineInstance.debugEnabled And profilerShow) Then Return
		
		If font Then SetImageFont font
		
		Local x:Float = 8.0, y:Float = 8.0
		Local xScale:Float, yScale:Float
		GetScale(xScale, yScale)
		Local str:String
		
		str = "         Profile Name         | tot/msec | avg/msec | % CPU | calls "
		DrawText str,x,y
		y:+Float(TextHeight(str) * yScale)
		
		str = "------------------------------+----------+----------+-------+-------"
		DrawText str,x,y
		y:+Float(TextHeight(str) * yScale)

		
		For Local result:TProfilerResult = EachIn Lresults
			str = LSet(RSet(result.name, result.name.length + result.level), 29)
			str :+ " | "
			str :+ RSet(Left(String.FromDouble(result.total_t),6),8)
			str :+ " | "
			str :+ RSet(Left(String.FromDouble(result.avg_t),6),8)
			str :+ " | "
			str :+ RSet(Left(String.FromDouble(result.total_t*100.0/dt),5),5)
			str :+ " | "
			str :+ RSet(Left(result.run_count,6),5)
			
			DrawText str,x,y
			y:+Float(TextHeight(str) * yScale)
		Next
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
		profilerEnabled = True
	End Method
	
	Method Disable()
		profilerEnabled = False
	End Method

	Method Show()
		profilerShow = True
	End Method
	
	Method Hide()
		profilerShow = False
	End Method		
			
End Type


Type TProfilerResult
	Field link:TLink

	Field name:String
	Field parent_name:String
	Field total_t:Double
	Field avg_t:Double
	Field level:Int
	Field run_count:Int
	
	Method FromSample(sample:TProfilerSample)
		name = sample.name
		If sample.parent
			parent_name = sample.parent.name
		Else
			parent_name = ""
		End If
		run_count = sample.run_count
		total_t = sample.get_t()
		avg_t = 0.0
		If total_t > 0.0 Then avg_t = total_t / run_count
		level = sample.level
	End Method
		
End Type


Type TProfilerSample
	Field name:String
	Field link:TLink
	Field running:Int
	Field start_t:Double
	Field end_t:Double
	Field total_t:Double
	Field level:Int
	Field parent:TProfilerSample
	Field run_count:Int
	
	Global global_level:Int		' Depth of nested profiling

	Global last_sample:TProfilerSample	' Last sample we have started
	
	
	Method New()
		running  = False
		total_t = 0.0
		run_count = 0.0
	End Method
	
	Function DeleteSample(sample:TProfilerSample)
		Assert(sample)
		
		RemoveLink(sample.link)
	End Function
	
	
	Method Start()
		If(running)
			TLogger.getInstance().LogWarning("[" + toString() + "] Sample already started: " + name)
			Return
		End If
		
		running = True
		level = global_level

		parent = last_sample
		last_sample = Self

	   global_level :+ 1
		start_t = rrMillisecs()
		run_count :+ 1
	End Method

		
	Method Stop()
		If(Not running)
			TLogger.getInstance().LogWarning("[" + toString() + "] Sample has not been started: " + name)
			Return
		End If
		
		last_sample = parent
		
		running = False
		global_level :- 1
		end_t = rrMillisecs()
		
		total_t :+ (end_t-start_t)
	End Method

	
	Method get_t:Double()
		Local t:Double = total_t
		total_t = 0.0
		run_count = 0.0
		Return t
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

Function rrShowProfiler()
	TProfiler.GetInstance().Show()
End Function

Function rrHideProfiler()
	TProfiler.GetInstance().Hide()
End Function