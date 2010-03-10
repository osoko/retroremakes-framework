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

Const GSH_MUSIC:Int = 0
Const GSH_SFX:Int = 1

rem
	bbdoc: Manages audio channels and sounds.
	about: The #TGameSoundHandler service manages audio channels and sounds.  When the
	service starts it allocates a specific number of channels and then uses/reuses these
	channels as necessary.  It currently uses the OpenAL driver.
endrem
Type TGameSoundHandler Extends TGameService

	rem
	bbdoc:The default number of channels that will be allocated when the service starts
	endrem
	Const MAX_CHANNELS:Int = 64
	
	Const DEFAULT_MASTER_VOLUME:Int = 100
	Const DEFAULT_MUSIC_VOLUME:Float = 0.8
	Const DEFAULT_SFX_VOLUME:Float = 1.0
	
	Global instance:TGameSoundHandler		' This holds the singleton instance of this Type

	Global LChannelsActive:TList = New TList
	Global LChannelsIdle:TList = New TList
	
	rem
	bbdoc: The maximum number of channels that will be allocated
	endrem
	Global maxChannels:Int = MAX_CHANNELS
	
	rem
	bbdoc: The maximum number of channels that have been used
	endrem
	Global maxUsed:Int = 0
	
	rem
	bbdoc: The total number of sounds played
	endrem
	Global soundsPlayed:Int = 0
	
	rem
	bbdoc: The current number of audio channels allocated
	endrem
	Global channelsAllocated:Int = 0
	
	rem
	bbdoc: The current number of active audio channels
	endrem
	Global activeChannels:Int = 0
	
	rem
	bbdoc: The current number of idle audio channels
	endrem
	Global idleChannels:Int = 0
	
	rem
	bbdoc: True if the sound engine is paused
	endrem
	Global soundPaused:Int = False

	Field LSounds:TList = New TList
	
	rem
	bbdoc: Array containing the volume settings for SFX and Music (0.0 to 1.0)
	endrem
	Field volumeSettings:Float[] = [0.8, 1.0]
	
	rem
	bbdoc: The current master volume
	endrem
	Field masterVolume:Float = 100
	
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod

	Function Create:TGameSoundHandler()
		Return TGameSoundHandler.GetInstance()		
	End Function
	
	rem
	bbdoc: Get the instance of the #TGameSoundHandler
	about: Either returns the current instance of #TGameSoundHandler or creates and returns a new instance
	returns: #TGameSoundHandler
	endrem
	Function GetInstance:TGameSoundHandler()
		If Not instance
			Return New TGameSoundHandler	
		Else
			Return instance
		EndIf
	EndFunction
	
	rem
	bbdoc: Initialises the instance of #TGameSoundHandler.  This method is called automatically on instantiation
	endrem
	Method Initialise()
		SetName("Game Sound Handler")
		Super.Initialise()
	End Method

	
	rem
	bbdoc: Shuts down the instance of #TGameSoundHandler.  This method is called automatically by the #TGameEngine instance
	endrem
	Method Shutdown()
		TLogger.GetInstance().LogInfo("[" + toString() + "] Channels used (Peak/Max): " + maxUsed + "/" + maxChannels)
		'TGameEngine.GetInstance().LogGlobal("AUDIO Total Sounds Played: " + soundsPlayed)
		Super.Shutdown()  'Call TGameService shutdown routines
	End Method	
		
	rem
	bbdoc: Starts the instance of #TGameSoundHandler.  This method is called automatically by the #TGameEngine instance
	endrem
	Method Start()
		EnableOpenALAudio()
		SetAudioDriver("OpenAL Default")
		AllocAllChannels()
		
		Local settings:TGameSettings = TGameSettings.GetInstance()
		
		Local masterVolume:Int = settings.GetIntVariable("AUDIO_MASTER_VOLUME", DEFAULT_MASTER_VOLUME, "Engine")
		Local musicVolume:Float = settings.GetFloatVariable("AUDIO_MUSIC_VOLUME", DEFAULT_MUSIC_VOLUME, "Engine")
		Local sfxVolume:Float = settings.GetFloatVariable("AUDIO_SFX_VOLUME", DEFAULT_SFX_VOLUME, "Engine")
		
		SetMasterVolume(masterVolume)
		SetMusicVolume(musicVolume)
		SetSfxVolume(sfxVolume)			
	End Method
	
	rem
	bbdoc: Sets the Master Volume for all audio channels
	about: Volume is in the range of 0-100
	endrem
	Method SetMasterVolume(vol:Int)
		If vol < 0 Then vol = 0
		If vol > 100 Then vol = 100
		masterVolume = vol
		SetChannelVolumes()
		TGameSettings.GetInstance().SetIntVariable("AUDIO_MASTER_VOLUME", vol, "Engine")
	End Method

	rem
	bbdoc: Gets the current master volume
	about: Volume is in the range of 0 to 100
	returns: Int
	endrem		
	Method GetMasterVolume:Int()
		Return masterVolume
	End Method

	rem
	bbdoc: Gets the current volume setting for Music channels
	about: Volume is in the range of 0.0 to 1.0 and is used as a multiplier of the Master Volume
	returns: Float
	endrem		
	Method GetMusicVolume:Float()
		Return volumeSettings[GSH_MUSIC]
	End Method

	rem
	bbdoc: Gets the current volume setting for SFX channels
	about: Volume is in the range of 0.0 to 1.0 and is used as a multiplier of the Master Volume
	returns: Float
	endrem			
	Method GetSfxVolume:Float()
		Return volumeSettings[GSH_SFX]
	End Method

	rem
	bbdoc: Sets the volume for music channels
	about: Volume is in the range of 0.0 to 1.0 and is used as a multiplier of the Master Volume
	endrem		
	Method SetMusicVolume(vol:Float)
		If vol < 0.0 Then vol = 0.0
		If vol > 1.0 Then vol = 1.0
		volumeSettings[GSH_MUSIC] = vol
		SetChannelVolumes()
		TGameSettings.GetInstance().SetFloatVariable("AUDIO_MUSIC_VOLUME", vol, "Engine")
	End Method

	rem
	bbdoc: Sets the volume for SFX channels
	about: Volume is in the range of 0.0 to 1.0 and is used as a multiplier of the Master Volume
	endrem	
	Method SetSfxVolume(vol:Float)
		If vol < 0.0 Then vol = 0.0
		If vol > 1.0 Then vol = 1.0
      volumeSettings[GSH_SFX] = vol
		SetChannelVolumes()
		TGameSettings.GetInstance().SetFloatVariable("AUDIO_SFX_VOLUME", vol, "Engine")
	End Method

	Rem
	bbdoc: Sets default volumes
	about: Sets Master, Music and SFX volumes to their default values
	endrem	
	Method SetDefaultVolumes()
		SetMasterVolume(DEFAULT_MASTER_VOLUME)
		SetMusicVolume(DEFAULT_MUSIC_VOLUME)
		SetSfxVolume(DEFAULT_SFX_VOLUME)
	End Method
	
	rem
	bbdoc: Sets the volume for all channels
	about: Uses the master volume and MUSIC and SFX volumes to set each audio channel's volume
	endrem
	Method SetChannelVolumes()
		For Local i:TGameSoundChannel = EachIn LChannelsActive
			Local vol:Float
			vol = volumeSettings[i.sound.gsClass] * (Float(masterVolume) / 100.0)
			i.SetVolume(vol)
		Next
	EndMethod
	
	rem
	bbdoc: Resets the audio handler
	endrem
	Method ResetSoundHandler()
		ClearList(LChannelsIdle)
		ClearList(LChannelsActive)
		
		maxUsed = 0
		channelsAllocated = 0
		activeChannels = 0
		idleChannels = 0		
	End Method
	
	rem
	bbdoc: Allocates all Audio Channels
	about: This is called automatically when the #TGameSoundHandler starts
	endrem
	Method AllocAllChannels()
		ResetSoundHandler()
		For Local i:Int = 1 To maxChannels
			Local _newChannel:TGameSoundChannel = TGameSoundChannel.Create()
			If _newChannel
				ListAddLast(LChannelsIdle, _newChannel) 
				channelsAllocated = i
				idleChannels = i
			Else
				Exit
			EndIf
		Next
	End Method
	
	Method LoadSound:TGameSound(url:Object, flags:Int = Null, priority:Int = 10, class:Int = GSH_SFX) 
		'Check it hasn't already been loaded.  If it has return the existing sound
		For Local s:TGameSound = EachIn LSounds
			If s.gsFilename = String(url) Then Return s
		Next
		Local _newSound:TGameSound = New TGameSound
		_newSound.gsHandle = brl.audio.LoadSound(url, flags) 
		If _newSound.gsHandle
			_newSound.gsClass = class
			_newSound.gsPriority = priority
			_newSound.gsFilename = String(url) 
			ListAddLast(LSounds, _newSound) 
			Return _newSound
		Else
			Return Null
		End If
	End Method
	
	Method PlaySound:TGameSoundChannel(sound:TGameSound, volume:Float = Null, pan:Float = 0.0, depth:Float = 0.0, rate:Float = 1.0)
		If Not sound Then Return Null
		Local channel:TGameSoundChannel
		If ListIsEmpty(LChannelsIdle) 
			'No idle channels so we need to find the oldest active channel with a lower
			'priority than the new sound		
			For Local c:TGameSoundChannel = EachIn LChannelsActive
				If c.sound.gsPriority <= sound.gsPriority
					'channel is a lower priority so replace it.
					Print "Replacing Channel"
					ListRemove(LChannelsActive, c) 
					ListAddLast(LChannelsActive, c)  	'move it to the end of the list as it's the newest soudd
					c.PauseChannel() 
					c.sound = Null
					channel = c
					Exit
				End If
			Next
		Else
			channel = TGameSoundChannel(LChannelsIdle.RemoveFirst())
			ListAddLast(LChannelsActive, channel) 
			idleChannels:-1
			activeChannels:+1
		EndIf
		
		If channel
			channel.CueSound(sound) 
			channel.SetVolume(volumeSettings[sound.gsClass] * (Float(masterVolume) / 100.0))
			channel.SetPan(pan) 
			channel.SetDepth(depth) 
			channel.SetRate(rate) 
			channel.ResumeChannel()
			soundsPlayed:+1
			Return channel
		EndIf
		Return Null
	End Method
	
	Method StopSound(sound:TGameSound)
		If Not sound Then Return
		For Local c:TGameSoundChannel = EachIn LChannelsActive
			If c.sound = sound
				'channel is a lower priority so replace it.
				c.channel.Stop()
				ListRemove(LChannelsActive, c)
				ListAddLast(LChannelsIdle, c)  	'move it to the end of the list as it's the newest soudd
				c.sound = Null
				idleChannels:-1
				activeChannels:+1
				Exit
			End If
		Next
	End Method	

	Method Suspend()
		PauseSound()
	End Method
	
	Method Resume()
		ResumeSound()
	End Method
	
	rem
	bbdoc: Pause all sound channels
	endrem
	Method PauseSound(pause:Int = True)
		For Local c:TGameSoundChannel = EachIn LChannelsActive
			c.channel.SetPaused(pause)
		Next
		soundPaused = True
	End Method
	
	rem
	bbdoc: Resume all paused sound channels
	endrem
	Method ResumeSound()
		For Local c:TGameSoundChannel = EachIn LChannelsActive
			c.channel.SetPaused(False)
		Next
		soundPaused = False
	End Method	
	
	rem
	bbdoc: Get the number of currently active channels
	endrem
	Method GetActiveChannels:Int() 
		Return activeChannels
	End Method

	rem
	bbdoc: Get the number of currently idle channels
	endrem
	Method GetIdleChannels:Int()
		Return idleChannels
	End Method

	rem
	bbdoc: Get the current max channels setting
	endrem
	Method GetMaxChannels:Int()
		Return maxChannels
	End Method

	rem
	bbdoc: Set the max number of channels that can be used
	endrem
	Method SetMaxChannels(value:Int)
		maxChannels = value
	End Method
	
	rem
	bbdoc: Get the maximum number of channels that have been used
	endrem
	Method GetMaxUsedChannels:Int() 
		Return maxUsed
	End Method
	
	rem
	bbdoc: Get the number of sounds currently loaded
	endrem
	Method GetNumSoundsLoaded:Int() 
		Return LSounds.Count() 
	End Method
		
	'Clean up finished sounds so channels can be re-used
	'TODO: Probably doesn't need to be run this often, also store TLinks with the TGameSoundChannel
	Method Update()
		If activeChannels > maxUsed Then maxUsed = activeChannels
		If Not soundPaused
			If Not ListIsEmpty(TGameSoundHandler.LChannelsActive)
				For Local i:TGameSoundChannel = EachIn TGameSoundHandler.LChannelsActive
					If Not i.ChannelPlaying() 
						ListRemove(TGameSoundHandler.LChannelsActive, i) 
						ListAddLast(TGameSoundHandler.LchannelsIdle , i) 
						i.sound = Null
						idleChannels:+1
						activeChannels:-1
					End If
				Next
			End If
		EndIf
	End Method
End Type
