extends AudioStreamPlayer

export var enable_music : bool = true

func _process(delta):
	if enable_music and !playing:
		play()
		
	if !enable_music and playing:
		stop()
