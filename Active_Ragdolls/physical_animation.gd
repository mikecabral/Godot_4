extends Skeleton3D

@export var enemy_controller: CharacterBody3D
@export var target_skeleton: Skeleton3D        # The animated skeleton
@export var enable_debug: bool = true
@export var ragdoll_duration: float = 0.2

@onready var simulator: PhysicalBoneSimulator3D = $PhysicalBoneSimulator3D

var physics_bones: Array
var full_ragdoll_mode := false
var root_bone: PhysicalBone3D = null
var temp_sim_running := false

func _ready():
	physics_bones = simulator.get_children().filter(func(x): return x is PhysicalBone3D)


func start_temporary_simulation(bone_name: StringName = "") -> void:
	if simulator.is_simulating_physics():
		return
	temp_sim_running = true
	simulator.physical_bones_start_simulation([bone_name])
	if enable_debug:
		print("Starting temporary simulation on bone:", bone_name)

	# Wait for the ragdoll_duration
	await get_tree().create_timer(ragdoll_duration).timeout

	simulator.physical_bones_stop_simulation()
	temp_sim_running = false
	if enable_debug:
		print("Temporary simulation ended for bone:", bone_name)

	# If enemy is dead and full ragdoll wasn't enabled yet, trigger it now
	if enemy_controller.dead and not full_ragdoll_mode:
		enable_full_ragdoll()


func enable_full_ragdoll() -> void:
	if full_ragdoll_mode:
		return # Already enabled
	full_ragdoll_mode = true

	# If a temporary simulation is still running, wait until it's done
	if temp_sim_running:
		if enable_debug:
			print("Waiting for temp simulation to finish before full ragdoll...")
		# Poll every frame until temp_sim_running is false
		while temp_sim_running:
			await get_tree().process_frame
		if enable_debug:
			print("Temp simulation finished, now starting full ragdoll.")

	# Start full physics simulation on all bones
	simulator.physical_bones_start_simulation()
	if enable_debug:
		print("✅ Full ragdoll enabled!")
