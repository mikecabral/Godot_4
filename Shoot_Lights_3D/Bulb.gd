extends RigidBody3D

@export var flicker_enabled: bool = false
@export var flicker_intensity_min: float = 0.5
@export var flicker_intensity_max: float = 1.2
@export var flicker_speed: float = 10.0

@onready var bulb_mesh: MeshInstance3D = $Bulb  # Adjust if needed
@onready var spotlight: SpotLight3D = $SpotLight3D  # Adjust if needed

var is_on: bool = true
var original_energy: float = 1.0
var flicker_timer: float = 0.0

func _ready() -> void:
	original_energy = spotlight.light_energy
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if flicker_enabled and is_on:
		flicker_timer += delta * flicker_speed
		var intensity: float = randf_range(flicker_intensity_min, flicker_intensity_max)
		spotlight.light_energy = original_energy * intensity

func hit_successful(_damage: int, attacker: Node = null) -> void:
	var _bullet_origin: Vector3 = attacker.global_transform.origin if attacker else global_transform.origin #added underscore
	shatter_bulb()



func shatter_bulb() -> void:
	print("DEBUG: Bulb shattered")
	turn_off_light()
	queue_free()

func turn_off_light() -> void:
	is_on = false
	flicker_enabled = false
	spotlight.light_energy = 0.0
	spotlight.visible = false
	_disable_bulb_emission()

func _disable_bulb_emission() -> void:
	var mat: Material = bulb_mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("emission_energy_multiplier", 0.0)

func turn_on_light() -> void:
	is_on = true
	spotlight.visible = true
	spotlight.light_energy = original_energy
	_enable_bulb_emission()

func _enable_bulb_emission() -> void:
	var mat: Material = bulb_mesh.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("emission_energy_multiplier", 1.75)

func toggle_light() -> void:
	if is_on:
		turn_off_light()
	else:
		turn_on_light()
