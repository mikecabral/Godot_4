#extends Sprite2D
extends ColorRect

#@onready var burn_effect: Sprite2D = $"../Sprite2D"
@onready var burn_effect: ColorRect = $"."

var threshold: float = 1.2
var delay: float = 2.0
var restart_delay: float = 1.0  # Time to wait before restarting
var restarting: bool = false



## RUN THE SCENE TO VIEW
func _ready() -> void:
	set_process(false)
	burn_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER


func _process(delta: float) -> void:
	if restarting:
		restart_delay -= delta
		if restart_delay <= 0:
			threshold = 1.2
			delay = 2.0
			restarting = false
		return

	delay -= delta
	if delay <= 0:
		burn_effect.get_material().set_shader_parameter("threshold", threshold)
		threshold -= delta * 0.2

		if threshold <= 0.0:
			restarting = true
			restart_delay = 1.0  # Reset restart delay
