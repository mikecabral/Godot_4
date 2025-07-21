extends ColorRect

@onready var speed_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	speed_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
