extends Node

export(NodePath) onready var glub_player_a = get_node(glub_player_a) as AudioStreamPlayer
export(NodePath) onready var glub_player_b = get_node(glub_player_b) as AudioStreamPlayer

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			glub()

func glub():
	if glub_player_a.playing or glub_player_b.playing:
		return
	if randi() % 2 == 0:
		glub_player_a.play()
	else:
		glub_player_b.play()
