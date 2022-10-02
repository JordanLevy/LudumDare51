extends RichTextLabel

var value = 0

func _ready():
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')
	GameEvents.connect("FoodEaten", self, "on_food_eaten")
	
func show_score():
	text = str(value)	
	
func on_main_menu():
	visible = true
	value = 0
	show_score()
	
func on_start_game():
	show_score()
	
func on_game_over():
	pass

func on_food_eaten():
	if value == 0:
		GameEvents.emit_signal("StartGame")
	value += 1
	show_score()
