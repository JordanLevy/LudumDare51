extends Node2D

var radius = 2000
var start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')
	
func on_main_menu():
	position = start_position
	
func on_start_game():
	pass
	
func on_game_over():
	pass

func _on_Area2D_body_entered(body):
	if GameEvents.game_state == GameEvents.GAME_OVER:
		return
	print("Food got ate")
	#Create new food nearby
	GameEvents.emit_signal("FoodEaten")
	GameEvents.emit_signal("PlaySound", "Eat")
	position = new_position()
	GameEvents.emit_signal("NewFood", position)


func new_position():
	var new_offset = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	return position + new_offset.normalized() * radius
