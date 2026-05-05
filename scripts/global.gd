extends Node

const menu_music: AudioStreamWAV = preload("res://assets/audio/music/start.wav")

@export var musicPlayer: AudioStreamPlayer

func _play_music (music: AudioStreamWAV, volume = 0.8):
	if musicPlayer.stream == music:
		return
	
	musicPlayer.stream = music
	musicPlayer.volume_db = volume
	musicPlayer.play()


func _on_music_player_ready() -> void:
	print("music ready")
	_play_music(menu_music)
	#pass
