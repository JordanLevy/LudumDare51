extends Node

const MAIN_MENU = 0
const PLAYING = 1
const GAME_OVER = 2

var game_state = MAIN_MENU

signal MainMenu

signal StartGame

signal GameOver

signal FoodEaten

signal NewFood(position)

signal ForgetControls

func _ready():
	connect("MainMenu", self, "on_main_menu")
	connect("StartGame", self, "on_start_game")
	connect("GameOver", self, "on_game_over")
	
func on_main_menu():
	game_state = MAIN_MENU
	
func on_start_game():
	game_state = PLAYING
	
func on_game_over():
	game_state = GAME_OVER


