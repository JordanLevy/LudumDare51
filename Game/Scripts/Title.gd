extends RichTextLabel

var start_height = 2300
var end_height = -300
var seconds_elapsed = 0.0
var duration = 5.0

func _ready():
	GameEvents.connect("MainMenu", self, "on_main_menu")
	
func on_main_menu():
	visible = false

func _process(delta):
	seconds_elapsed = Time.get_ticks_msec() /1000.0
	var amount = seconds_elapsed / duration
	amount = min(amount, 1.0)
	rect_position.y = lerp(start_height, end_height, amount)
