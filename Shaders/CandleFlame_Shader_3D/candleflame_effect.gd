extends ColorRect

@onready var candle_flame_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	candle_flame_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
