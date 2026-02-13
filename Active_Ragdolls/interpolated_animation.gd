extends Skeleton3D

@export_range(0.0, 1.0) var physics_interpolation: float = 0.5
@export var physics_interpolation_speed: float = 5.0

@export var physics_skeleton: Skeleton3D
@export var animated_skeleton: Skeleton3D

@export var interpolated_mesh: MeshInstance3D
@export var physics_mesh: MeshInstance3D

var physics_bones
var bone_rot_offsets = {}
var full_ragdoll_mode := false

func _ready():
#	physics_bones = physics_skeleton.get_children().filter(func(x): return x is PhysicalBone3D)

	interpolated_mesh.show()
	physics_mesh.hide()

	var simulator = physics_skeleton.get_node("PhysicalBoneSimulator3D")
	physics_bones = simulator.get_children().filter(func(x): return x is PhysicalBone3D)


	for b in physics_bones:
		var bone_id = b.get_bone_id()
		if bone_id == -1:
			continue

		var physics_basis = b.global_transform.basis
		var anim_basis = animated_skeleton.get_bone_global_pose(bone_id).basis
		bone_rot_offsets[bone_id] = anim_basis * physics_basis.inverse()

func _physics_process(delta):
	for b in physics_bones:
		var bone_id = b.get_bone_id()
		if bone_id == -1:
			continue

		var physics_global = b.global_transform

		# --- FULL RAGDOLL MODE: override directly, no interpolation ---
		if full_ragdoll_mode:
			interpolated_mesh.hide()
			physics_mesh.show()
		else:
			interpolated_mesh.show()
#			var local_physics = global_transform.affine_inverse() * physics_global
#			set_bone_global_pose_override(bone_id, local_physics, 1.0, true)
#			continue  # <-- NO interpolation at all, exit here

		# --- INTERPOLATED BLENDING ---
		var animated_global = animated_skeleton.global_transform * animated_skeleton.get_bone_global_pose(bone_id)

		if physics_interpolation < 1.0 and bone_rot_offsets.has(bone_id):
			physics_global.basis = bone_rot_offsets[bone_id] * physics_global.basis

		var blend_amount = clamp(physics_interpolation * physics_interpolation_speed * delta, 0.0, 1.0)
		var blended_global = animated_global.interpolate_with(physics_global, blend_amount)
		var local_blended = global_transform.affine_inverse() * blended_global
		set_bone_global_pose_override(bone_id, local_blended, 1.0, true)


func enable_full_ragdoll():
	full_ragdoll_mode = true
