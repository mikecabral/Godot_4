extends ColorRect

@onready var vertical_drops_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	vertical_drops_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
