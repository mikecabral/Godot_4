extends ColorRect

@onready var ellipses_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	ellipses_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
