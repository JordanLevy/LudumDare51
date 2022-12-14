extends RigidBody2D

export(NodePath) onready var camera = get_node(camera) as Camera2D
export(NodePath) onready var anim_tail = get_node(anim_tail) as AnimationPlayer
export(NodePath) onready var anim_lf = get_node(anim_lf) as AnimationPlayer
export(NodePath) onready var anim_rf = get_node(anim_rf) as AnimationPlayer
export(NodePath) onready var lf_label = get_node(lf_label) as Button
export(NodePath) onready var rf_label = get_node(rf_label) as Button
export(NodePath) onready var lt_label = get_node(lt_label) as Button
export(NodePath) onready var rt_label = get_node(rt_label) as Button

var reset_state = false

var splash_tail_timer = null
var num_splash_tail = 0
var done_splash = false

var camera_follow = false

var controls_list : Array = [KEY_O, KEY_P, KEY_Q, KEY_W]
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
	
func get_key_color(val):
	var stylebox_flat := StyleBoxFlat.new()
	stylebox_flat.bg_color = Color("96ffffff")
	if val == KEY_Q:
		stylebox_flat.bg_color = Color("96ff0000")
	elif val == KEY_W:
		stylebox_flat.bg_color = Color("960c00ff")
	elif val == KEY_O:
		stylebox_flat.bg_color = Color("9646ff00")
	elif val == KEY_P:
		stylebox_flat.bg_color = Color("969500ff")
	return stylebox_flat
	

func set_control_labels():
	lf_label.text = get_key_letter(lf_key)
	lf_label.add_stylebox_override("disabled",  get_key_color(lf_key))
	rf_label.text = get_key_letter(rf_key)
	rf_label.add_stylebox_override("disabled",  get_key_color(rf_key))
	lt_label.text = get_key_letter(lt_key)
	lt_label.add_stylebox_override("disabled",  get_key_color(lt_key))
	rt_label.text = get_key_letter(rt_key)
	rt_label.add_stylebox_override("disabled",  get_key_color(rt_key))
	
func release_all_buttons():
	if lf_down:
		release_flipper(-1)
		lf_down = false
	if rf_down:
		release_flipper(1)
		rf_down = false
	lt_down = false
	rt_down = false
	
func set_keys():
	lf_key = controls_list[0]
	rf_key = controls_list[1]
	lt_key = controls_list[2]
	rt_key = controls_list[3]
	release_all_buttons()
	set_control_labels()

func shuffle():
	controls_list.shuffle()
	set_keys()
	
func on_splash_screen():
	camera_follow = false
	controls_list = [KEY_O, KEY_P, KEY_Q, KEY_W]
	reset_state = false
	#set_keys()
	
	splash_tail_timer = Timer.new()
	add_child(splash_tail_timer)

	splash_tail_timer.connect("timeout", self, "_onsplash_tail_timer_timeout")
	splash_tail_timer.set_wait_time(0.25)
	splash_tail_timer.set_one_shot(false) # Make sure it loops
	splash_tail_timer.start()
	
func on_main_menu():
	camera_follow = true
	controls_list = [KEY_O, KEY_P, KEY_Q, KEY_W]
	reset_state = true
	set_keys()
	
func on_start_game():
	pass
	
func on_game_over():
	release_all_buttons()

func _ready():
	GameEvents.connect("SplashScreen", self, 'on_splash_screen')
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')
	GameEvents.connect("ForgetControls", self, "shuffle")
	GameEvents.emit_signal("SplashScreen")

func _onsplash_tail_timer_timeout():
	num_splash_tail += 1
	if not done_splash:
		if tail_side == -1:
			thrust(1)
		elif tail_side == 1:
			thrust(-1)
	if num_splash_tail == 3:
		lf_down = true
		use_flipper(-1)
	if num_splash_tail == 7:
		lf_down = false
		release_flipper(-1)
	if num_splash_tail == 8:
		rf_down = true
		use_flipper(1)
	if num_splash_tail == 12:
		rf_down = false
		release_flipper(1)
	if num_splash_tail >= 16:
		done_splash = true
	if num_splash_tail >= 18 && done_splash:
		splash_tail_timer.stop()
		GameEvents.emit_signal("MainMenu")

func _physics_process(delta):
	if camera_follow:
		camera.global_position = global_position
	if reset_state:
		transform = Transform2D(0.0, Vector2(0, 0))
		linear_velocity = Vector2(0, 0)
		angular_velocity = 0
		add_torque(-applied_torque)
		reset_state = false
		return
	if GameEvents.game_state == GameEvents.GAME_OVER:
		return
	var flipper_side = 0
	if lf_down:
		flipper_side -= 1
	if rf_down:
		flipper_side += 1
	add_torque((200 + log(1 + linear_velocity.length())) * flipper_side * 0.7)
	add_torque(angular_velocity * -20)
	
func use_flipper(side):
	if side == -1:
		anim_lf.play("FlipperLeft")
	elif side == 1:
		anim_rf.play("FlipperRight")
	GameEvents.emit_signal('PlaySound', "Turn")
		
func release_flipper(side):
	if side == -1:
		anim_lf.play("FlipperLeftRelease")
	elif side == 1:
		anim_rf.play("FlipperRightRelease")
	
func thrust(side):
	if side == -1:
		GameEvents.emit_signal('PlaySound', "ThrustLeft")
		anim_tail.play("TailLeft")
	elif side == 1:
		GameEvents.emit_signal('PlaySound', "ThrustRight")
		anim_tail.play("TailRight")
	tail_side = side;
	apply_impulse(Vector2.ZERO, -transform.y * 10)
	
func game_input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			GameEvents.emit_signal('PlaySound', "Glub")
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
	if GameEvents.game_state == GameEvents.SPLASH_SCREEN:
		if event is InputEventKey and event.pressed:
			if event.scancode == KEY_SPACE:
				thrust(-1)
				splash_tail_timer.stop()
				GameEvents.emit_signal("MainMenu")
		game_input(event)
	elif GameEvents.game_state == GameEvents.MAIN_MENU:
		game_input(event)
	elif GameEvents.game_state == GameEvents.PLAYING:
		game_input(event)
	elif GameEvents.game_state == GameEvents.GAME_OVER:
		if event is InputEventKey and event.pressed:
			if event.scancode == KEY_SPACE:
				GameEvents.emit_signal("MainMenu")
