extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var food_position


	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("NewFood", self, "on_new_food")

func _process(delta):
	if not food_position:
		return
	var dy = food_position.y - global_position.y
	var dx = food_position.x - global_position.x
	var food_angle = atan2(dy, dx) + PI/2
	rotation = food_angle


func on_new_food(position):
	food_position = position
	print("New food at", position)
