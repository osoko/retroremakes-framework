
Function rrLoadSound:TGameSound(url:Object, flags:Int = Null, priority:Int = 10, class:Int = GSH_SFX)
	Return TGameSoundHandler.GetInstance().LoadSound(url, flags, priority, class)
End Function

Function rrPlaySound:TGameSoundChannel(sound:TGameSound, volume:Float = Null, pan:Float = 0.0, depth:Float = 0.0, rate:Float = 1.0)
	Return TGameSoundHandler.GetInstance().PlaySound(sound, volume, pan, depth, rate)
End Function

Function rrStopSound(sound:TGameSound)
	TGameSoundHandler.GetInstance().StopSound(sound)
End Function

Function rrSetMasterVolume(volume:Int)
	TGameSoundHandler.GetInstance().SetMasterVolume(volume)
End Function

Function rrPauseSound(pause:Int)
	TGameSoundHandler.GetInstance().PauseSound(pause)
End Function
