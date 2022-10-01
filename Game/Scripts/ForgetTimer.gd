extends TextureProgress

var timer = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	value = round(timer) * 10
	if timer <= 0:
		GameEvents.emit_signal("ForgetControls")
		timer = 10.0
