extends ToolButton

export (Texture) var enabled_icon
export (Texture) var disabled_icon
export(NodePath) onready var background_music = get_node(background_music) as Node

func _ready():
	toggle_mode = true
	icon = enabled_icon
	connect("toggled", self, "toggle_music")

func toggle_music(button_on):
	if !button_on:
		icon = enabled_icon
		background_music.enable_music = true
	else:
		icon = disabled_icon
		background_music.enable_music = false
