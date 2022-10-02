extends Node2D

var radius = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
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
