extends Skeleton3D

@export var target_skeleton: Skeleton3D        # The animated skeleton
@export var enable_debug: bool = true          # Toggle debug logs
@export var ragdoll_duration: float = 0.2

@onready var simulator: PhysicalBoneSimulator3D = $PhysicalBoneSimulator3D

var physics_bones: Array
var full_ragdoll_mode := false
var root_bone: PhysicalBone3D = null

func _ready():

#	await get_tree().create_timer(2.0).timeout

	physics_bones = simulator.get_children().filter(func(x): return x is PhysicalBone3D)

func start_temporary_simulation(bone_name: StringName = "") -> void:
	if bone_name == "":
		simulator.physical_bones_start_simulation()
	else:
		simulator.physical_bones_start_simulation([bone_name])

	print("starting temp simulation...")

	await get_tree().create_timer(ragdoll_duration).timeout

	print("ending temp simulation...")
	simulator.physical_bones_stop_simulation()

func enable_full_ragdoll() -> void:
	simulator.physical_bones_start_simulation()
