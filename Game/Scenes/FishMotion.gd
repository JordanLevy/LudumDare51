extends RigidBody2D

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer

var controls_list : Array = [KEY_Q, KEY_W, KEY_O, KEY_P]
var lf_key #left flipper
var rf_key #right flipper
var lt_key #left tail
var rt_key #right tail

var lf_down = false
var rf_down = false
var lt_down = false
var rt_down = false

var tail_side = -1

func shuffle():
	controls_list.shuffle()
	lf_key = controls_list[0]
	rf_key = controls_list[1]
	lt_key = controls_list[2]
	rt_key = controls_list[3]

func display():
	print(controls_list)

func _on_Randomizer_timeout():
	shuffle()
	display()

func _ready():
	#randomize()
	shuffle()
	display()

func _physics_process(delta):
	var flipper_side = 0
	if lf_down:
		flipper_side -= 1
	if rf_down:
		flipper_side += 1
	add_torque(linear_velocity.length() * flipper_side * 5)
	
func use_flipper(side):
	if side == -1:
		animation_player.play("FlipperLeft")
	elif side == 1:
		animation_player.play("FlipperRight")
		
func release_flipper(side):
	if side == -1:
		animation_player.play("FlipperLeftRelease")
	elif side == 1:
		animation_player.play("FlipperRightRelease")
	
func thrust(side):
	if side == -1:
		animation_player.play("TailLeft")
	elif side == 1:
		animation_player.play("TailRight")
	tail_side = side;
	apply_impulse(Vector2.ZERO, -transform.y * 10)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == lf_key:
			if not lf_down:
				use_flipper(-1)
			lf_down = true
		if event.scancode == rf_key:
			if not rf_down:
				use_flipper(1)
			rf_down = true
		if event.scancode == lt_key:
			if not lt_down and not rt_down and tail_side != -1:
				thrust(-1)
			lt_down = true
		if event.scancode == rt_key:
			if not lt_down and not rt_down and tail_side != 1:
				thrust(1)
			rt_down = true
	if event is InputEventKey and not event.pressed:
		if event.scancode == lf_key:
			release_flipper(-1)
			lf_down = false
		if event.scancode == rf_key:
			release_flipper(1)
			rf_down = false
		if event.scancode == lt_key:
			if rt_down:
				thrust(1)
			lt_down = false
		if event.scancode == rt_key:
			if lt_down:
				thrust(-1)
			rt_down = false
