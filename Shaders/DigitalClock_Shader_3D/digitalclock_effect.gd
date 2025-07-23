extends ColorRect

@onready var digital_clock_effect: ColorRect = $"."

func _ready() -> void:
#	set_process(false)
#	digital_clock_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER

func _process(delta: float) -> void:
	var dict = Time.get_datetime_dict_from_system()
	digital_clock_effect.material.set_shader_parameter("hour", dict.hour)
	digital_clock_effect.material.set_shader_parameter("minute", dict.minute)
	digital_clock_effect.material.set_shader_parameter("second", dict.second)

	# Blink colon: on when even second, off when odd
	var blink_on = dict.second % 2 == 0
	digital_clock_effect.material.set_shader_parameter("blink_colon", blink_on)
