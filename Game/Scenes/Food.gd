extends Node2D

var radius = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	print("Food got ate")
	#Create new food nearby
	GameEvents.emit_signal('FoodEaten')
	position = new_position()
	GameEvents.emit_signal('NewFood', position)


func new_position():
	var new_offset = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	return position + new_offset.normalized() * radius
