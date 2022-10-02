extends TextureProgress

var timer = 10.0

func _ready():
	GameEvents.connect("MainMenu", self, 'on_main_menu')
	GameEvents.connect("StartGame", self, 'on_start_game')
	GameEvents.connect("GameOver", self, 'on_game_over')

func on_main_menu():
	timer = 10.0
	value = 100
	
func on_start_game():
	timer = 10.0
	value = 100
	
func on_game_over():
	pass

func _process(delta):
	if GameEvents.game_state != GameEvents.PLAYING:
		return
	timer -= delta
	value = round(timer) * 10
	if timer <= 0:
		GameEvents.emit_signal("ForgetControls")
		timer = 10.0
