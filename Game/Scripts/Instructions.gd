extends Control

func _ready():
	GameEvents.connect("SplashScreen", self, "on_splash_screen")
	GameEvents.connect("MainMenu", self, "on_main_menu")
	GameEvents.connect("StartGame", self, "on_start_game")
	GameEvents.connect("GameOver", self, "on_game_over")

func on_splash_screen():
	visible = false

func on_main_menu():
	visible = true
	
func on_start_game():
	visible = false
	
func on_game_over():
	visible = false
