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

Type TProfilerResult
	Field link:TLink

	Field name:String
	Field parent_name:String
	Field total_t:Double
	Field avg_t:Double
	Field min_t:Double
	Field max_t:Double
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
		min_t = sample._min_t
		max_t = sample._max_t
	End Method
		
End Type