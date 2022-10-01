extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hunger_per_second = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("FoodEaten", self, 'on_food_eaten')
	pass # Replace with function body.


func on_food_eaten():
	value += 20
	if value > max_value:
		value = max_value
		
func _process(delta):
	value -= hunger_per_second * delta
