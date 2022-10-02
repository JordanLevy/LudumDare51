extends Node

var controls_list : Array = [KEY_Q, KEY_W, KEY_O, KEY_P]
var left_turn
var right_turn
var left_tail
var right_tail

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	shuffle()
	display()

func shuffle():
	controls_list.shuffle()
	left_turn = controls_list[0]
	right_turn = controls_list[1]
	left_tail = controls_list[2]
	right_tail = controls_list[3]

func display():
	print(controls_list)

func _on_Randomizer_timeout():
	shuffle()
	display()
