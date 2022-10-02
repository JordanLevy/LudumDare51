extends ProgressBar

var hunger_per_second = 4

func _ready():
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')
	GameEvents.connect("FoodEaten", self, 'on_food_eaten')

func on_main_menu():
	value = 0
	
func on_start_game():
	value = 100
	
func on_game_over():
	pass

func on_food_eaten():
	value = 100
	if value > max_value:
		value = max_value
		
func _process(delta):
	if GameEvents.game_state != GameEvents.PLAYING:
		return
	value -= hunger_per_second * delta
	if value <= 0:
		GameEvents.emit_signal("GameOver")
