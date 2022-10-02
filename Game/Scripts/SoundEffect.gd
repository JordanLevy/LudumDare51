extends Node

var audio_players
var num_audio_players

func _ready():
	audio_players = get_children()
	num_audio_players = len(audio_players)
	GameEvents.connect("PlaySound", self, "on_play_sound")
			
func on_play_sound(sound):
	if sound == name:
		print(sound)
		var i = randi() % num_audio_players
		audio_players[i].play()
