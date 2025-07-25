extends ColorRect

@onready var sierpinksi_triangle_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	sierpinksi_triangle_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
