@tool
extends ColorRect

@onready var color_palette_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	color_palette_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
