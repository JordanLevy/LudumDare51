extends Node2D

func _ready():
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')

func on_main_menu():
	visible = false
	
func on_start_game():
	visible = false
	
func on_game_over():
	visible = true