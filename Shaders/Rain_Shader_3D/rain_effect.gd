extends ColorRect

@onready var rain_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	rain_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
