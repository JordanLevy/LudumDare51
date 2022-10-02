extends RichTextLabel

var value = 0

func _ready():
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')
	GameEvents.connect("FoodEaten", self, "on_food_eaten")
	
func on_main_menu():
	value = 0
	
func on_start_game():
	value = 0
	
func on_game_over():
	pass

func on_food_eaten():
	if value == 0:
		GameEvents.emit_signal("StartGame")
	value += 1
