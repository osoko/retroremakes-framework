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

rem
	bbdoc: Audio output channel.
endrem
Type TGameSoundChannel
	Field channel:TChannel
	Field sound:TGameSound
	
	Field gscDepth:Float = 0.0
	Field gscPan:Float = 0.0
	Field gscRate:Float = 1.0
	Field gscVolume:Float = 1.0
	
	Method SetDepth(value:Float) 
		If Not channel Then Return
		gscDepth = value
		If value < -1.0 Then value = -1.0
		If value > 1.0 Then value = 1.0
		channel.SetDepth(gscDepth) 
	End Method
	
	Method SetPan(value:Float) 
		If Not channel Then Return
		gscPan = value
		If value < - 1.0 Then value = -1.0
		If value > 1.0 Then value = 1.0
		channel.SetPan(gscPan) 
	End Method
	
	Method SetRate(value:Float) 
		If Not channel Then Return
		gscRate = value
		channel.SetRate(gscRate) 
	End Method
	
	Method SetVolume(value:Float) 
		If Not channel Then Return
		If value < 0.0 Then value = 0.0
		If value > 1.0 Then value = 1.0
		gscVolume = value
		channel.SetVolume(gscVolume) 
	End Method
	
	Function Create:TGameSoundChannel() 
		Local newGameSoundChannel:TGameSoundChannel = New TGameSoundChannel
		newGameSoundChannel.channel = AllocChannel() 
		If Not newGameSoundChannel.channel
			Return Null
		Else
			Return newGameSoundChannel
		EndIf
	EndFunction
	
	Method CueSound(s:TGameSound) 
		sound = s
		brl.audio.CueSound(sound.gsHandle, channel) 
	End Method

	Method ResumeChannel() 
		If Not channel Then Return
		brl.audio.ResumeChannel(channel) 
	EndMethod
	
	Method ChannelPlaying:Int()
		Return brl.audio.ChannelPlaying(channel)
	EndMethod
	
	Method PauseChannel:Int() 
		Return brl.audio.PauseChannel(channel) 
	End Method
	
EndType
