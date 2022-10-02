extends RigidBody2D

export(NodePath) onready var camera = get_node(camera) as Camera2D
export(NodePath) onready var anim_tail = get_node(anim_tail) as AnimationPlayer
export(NodePath) onready var anim_lf = get_node(anim_lf) as AnimationPlayer
export(NodePath) onready var anim_rf = get_node(anim_rf) as AnimationPlayer
export(NodePath) onready var splash_sound = get_node(splash_sound) as AudioStreamPlayer
export(NodePath) onready var lf_label = get_node(lf_label) as Button
export(NodePath) onready var rf_label = get_node(rf_label) as Button
export(NodePath) onready var lt_label = get_node(lt_label) as Button
export(NodePath) onready var rt_label = get_node(rt_label) as Button

var controls_list : Array
var lf_key
var rf_key
var lt_key
var rt_key

var lf_down = false
var rf_down = false
var lt_down = false
var rt_down = false

var tail_side = -1

func get_key_letter(val):
	if val == KEY_Q:
		return "Q"
	elif val == KEY_W:
		return "W"
	elif val == KEY_O:
		return "O"
	elif val == KEY_P:
		return "P"
	return "-"
	

func set_control_labels():
	lf_label.text = get_key_letter(lf_key)
	rf_label.text = get_key_letter(rf_key)
	lt_label.text = get_key_letter(lt_key)
	rt_label.text = get_key_letter(rt_key)
	
func release_all_buttons():
	lf_down = false
	rf_down = false
	lt_down = false
	rt_down = false

func shuffle():
	controls_list.shuffle()
	lf_key = controls_list[0]
	rf_key = controls_list[1]
	lt_key = controls_list[2]
	rt_key = controls_list[3]
	release_all_buttons()
	set_control_labels()
	
func on_main_menu():
	controls_list = [KEY_Q, KEY_W, KEY_O, KEY_P]
	global_position = Vector2.ZERO
	global_rotation = 0
	shuffle()
	
func on_start_game():
	pass
	
func on_game_over():
	release_all_buttons()

func _ready():
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')
	GameEvents.connect("ForgetControls", self, "shuffle")
	GameEvents.emit_signal("MainMenu")

func _physics_process(delta):
	var flipper_side = 0
	if lf_down:
		flipper_side -= 1
	if rf_down:
		flipper_side += 1
	add_torque((200 + log(1 + linear_velocity.length())) * flipper_side * 0.7)
	add_torque(angular_velocity * -20)
	camera.global_position = global_position
	
func use_flipper(side):
	if side == -1:
		anim_lf.play("FlipperLeft")
	elif side == 1:
		anim_rf.play("FlipperRight")
		
func release_flipper(side):
	if side == -1:
		anim_lf.play("FlipperLeftRelease")
	elif side == 1:
		anim_rf.play("FlipperRightRelease")
	
func thrust(side):
	if side == -1:
		anim_tail.play("TailLeft")
	elif side == 1:
		anim_tail.play("TailRight")
	tail_side = side;
	if not splash_sound.playing:
		splash_sound.play()
	apply_impulse(Vector2.ZERO, -transform.y * 10)
	
func game_input(event):
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
			if rt_down and tail_side == -1:
				thrust(1)
			lt_down = false
		if event.scancode == rt_key:
			if lt_down and tail_side == 1:
				thrust(-1)
			rt_down = false

func _input(event):
	if GameEvents.game_state == GameEvents.MAIN_MENU:
		if event is InputEventKey and event.pressed:
			if event.scancode == KEY_SPACE:
				GameEvents.emit_signal("StartGame")
		game_input(event)
	if GameEvents.game_state == GameEvents.PLAYING:
		game_input(event)
	elif GameEvents.game_state == GameEvents.GAME_OVER:
		if event is InputEventKey and event.pressed:
			if event.scancode == KEY_SPACE:
				GameEvents.emit_signal("MainMenu")
