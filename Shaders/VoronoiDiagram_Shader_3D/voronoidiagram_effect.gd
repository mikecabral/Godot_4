extends ColorRect

@onready var voronoi_diagram_effect: ColorRect = $"."

func _ready() -> void:
	set_process(false)
	voronoi_diagram_effect.hide()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE  # DISABLE MOUSE CAPTURING PRIORITY FOR SHADER
