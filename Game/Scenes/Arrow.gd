extends Sprite

export(NodePath) onready var food_node = get_node(food_node) as Node2D

func _process(delta):
	var dy = food_node.position.y - global_position.y
	var dx = food_node.position.x - global_position.x
	var food_angle = atan2(dy, dx) + PI/2
	rotation = food_angle

