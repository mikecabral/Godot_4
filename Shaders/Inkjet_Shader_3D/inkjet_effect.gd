extends ColorRect

@onready var inkjet_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	inkjet_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
