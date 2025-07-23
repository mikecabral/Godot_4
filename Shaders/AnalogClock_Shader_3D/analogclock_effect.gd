@tool
extends ColorRect

@onready var analog_clock_effect: ColorRect = $"."

func _ready() -> void:
#	set_process(false)
#	analog_clock_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER

func _process(delta: float) -> void:
	var dict = Time.get_datetime_dict_from_system()
	analog_clock_effect.material.set_shader_parameter("hour", dict.hour)
	analog_clock_effect.material.set_shader_parameter("minute", dict.minute)
	analog_clock_effect.material.set_shader_parameter("second", dict.second)
