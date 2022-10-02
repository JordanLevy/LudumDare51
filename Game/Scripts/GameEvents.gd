extends Node

const SPLASH_SCREEN = 0
const MAIN_MENU = 1
const PLAYING = 2
const GAME_OVER = 3

var game_state = SPLASH_SCREEN

signal SplashScreen

signal MainMenu

signal StartGame

signal GameOver

signal FoodEaten

signal NewFood(position)

signal ForgetControls

signal PlaySound(sound)

func _ready():
	connect("SplashScreen", self, "on_splash_screen")
	connect("MainMenu", self, "on_main_menu")
	connect("StartGame", self, "on_start_game")
	connect("GameOver", self, "on_game_over")
	
func on_splash_screen():
	game_state = SPLASH_SCREEN
	
func on_main_menu():
	game_state = MAIN_MENU
	
func on_start_game():
	game_state = PLAYING
	
func on_game_over():
	game_state = GAME_OVER


