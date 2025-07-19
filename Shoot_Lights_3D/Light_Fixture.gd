extends RigidBody3D

# === ENUMS ===
enum LightType { STATIC, DYNAMIC }

# === EXPORTED VARIABLES ===
@export_enum("STATIC", "DYNAMIC") var light_type: int = LightType.STATIC
@export var can_be_shot: bool = true

func _ready() -> void:
	set_physics_process(true)

	if light_type == LightType.STATIC:
		freeze = true
		linear_damp = 1000.0
		angular_damp = 1000.0
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		sleeping = true

func _physics_process(_delta: float) -> void:
	# No flicker logic here anymore
	pass

func hit_light(global_hit_position: Vector3) -> void:
	if not can_be_shot:
		return

	if light_type == LightType.DYNAMIC:
		_add_swing_impulse(global_hit_position)

func hit_successful(_damage: int, attacker: Node = null) -> void:
	var bullet_origin: Vector3 = attacker.global_transform.origin if attacker else global_transform.origin
	hit_light(bullet_origin)

func _add_swing_impulse(hit_point: Vector3) -> void:
	var impulse_dir: Vector3 = (global_transform.origin - hit_point).normalized()
	apply_impulse(Vector3.ZERO, impulse_dir * 5.0)
