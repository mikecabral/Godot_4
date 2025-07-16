## Blood Particle

extends Area3D

# Movement
var velocity := Vector3(
	randf_range(-3.0, 3.0),
	randf_range(0.5, 3.0),
	randf_range(-3.0, 3.0)
)

var is_colliding := false
var do_wobble := false
var max_count := randf_range(10, 50)
var count := 0
var lifetime := 0.0
var max_lifetime := 5.0
var paint_timer := 0.0
var paint_interval := 0.1  # Paint every 0.1 seconds
var last_paint_point := Vector3.ZERO
var current_collision_normal := Vector3.UP

func _ready():
	monitorable = true
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float):
	lifetime += delta
	paint_timer += delta
	HandleBloodMovement(delta)

	# Do a downward ray every frame if not colliding yet
	if not is_colliding:
		var space = get_world_3d().direct_space_state
		var down_ray = PhysicsRayQueryParameters3D.create(
			global_position,
			global_position - Vector3.UP * 0.2
		)
		down_ray.collide_with_areas = true
		down_ray.collide_with_bodies = true
		down_ray.exclude = [self]
		var result = space.intersect_ray(down_ray)
		
		if result:
			# Just landed on something
			is_colliding = true
			do_wobble = true
			last_paint_point = result.position
			current_collision_normal = result.normal
			Surface.draw_blood(result.position, result.normal)

			# Realistic splash logic with consistent speed
			var chance = randf()

			if chance < 0.2:
				# Small normal spray (front)
				var splash_vector = result.normal * randf_range(0.3, 0.6)
				splash_vector += Vector3(
					randf_range(-0.2, 0.2),
					randf_range(-0.1, 0.1),
					randf_range(-0.2, 0.2)
				)
				velocity = splash_vector.normalized() * randf_range(5.0, 8.0)

			elif chance < 0.9:
				# Large opposite spray (back)
				var splash_vector = -result.normal * randf_range(0.6, 1.2)
				splash_vector += Vector3(
					randf_range(-0.5, 0.5),
					randf_range(-0.2, 0.2),
					randf_range(-0.5, 0.5)
				)
				velocity = splash_vector.normalized() * randf_range(8.0, 14.0)

			else:
				# Upward spray
				var splash_vector = Vector3(
					randf_range(-0.3, 0.3),
					randf_range(0.8, 1.5),
					randf_range(-0.3, 0.3)
				)
				velocity = splash_vector.normalized() * randf_range(6.0, 10.0)

	# Continuous painting while on surface
	if is_colliding and paint_timer >= paint_interval:
		paint_timer = 0.0
		var paint_position = last_paint_point.lerp(global_position, 0.5)
		Surface.draw_blood(paint_position, current_collision_normal)
		last_paint_point = global_position

	if (
		abs(position.x) > 1000 or
		abs(position.y) > 1000 or
		abs(position.z) > 1000 or
		lifetime > max_lifetime
	):
		queue_free()

func HandleBloodMovement(delta: float):
	velocity.y -= 9.8 * delta  # gravity always applies

	if not is_colliding:
		velocity *= pow(0.98, delta * 60)
	else:
		count += 1
		if count > max_count:
			queue_free()
		if do_wobble:
			velocity.x += randf_range(-0.01, 0.01) * delta * 60

			velocity.z += randf_range(-0.01, 0.01) * delta * 60

	position += velocity * delta

func _on_body_entered(body: Node3D):
	pass  # No longer needed

func _on_body_exited(body: Node3D):
	pass  # No longer needed




# FIXED DEBUG FUNCTION
#func _debug_draw_collision(pos: Vector3, normal: Vector3):
	# Create debug sphere
#	var debug_sphere = MeshInstance3D.new()
#	var sphere_mesh = SphereMesh.new()
#	sphere_mesh.radius = 0.05
#	debug_sphere.mesh = sphere_mesh

#	var red_material = StandardMaterial3D.new()
#	red_material.albedo_color = Color.RED
#	debug_sphere.material_override = red_material

#	debug_sphere.global_position = pos
#	get_tree().root.add_child(debug_sphere)

	# Create debug normal indicator
#	var debug_line = MeshInstance3D.new()
#	var cylinder_mesh = CylinderMesh.new()
#	cylinder_mesh.height = 0.5
#	cylinder_mesh.top_radius = 0.01
#	cylinder_mesh.bottom_radius = 0.01
#	debug_line.mesh = cylinder_mesh

#	var green_material = StandardMaterial3D.new()
#	green_material.albedo_color = Color.GREEN
#	debug_line.material_override = green_material

#	debug_line.global_position = pos + normal * 0.25
#	debug_line.look_at(pos + normal, Vector3.UP)
#	get_tree().root.add_child(debug_line)

	# Auto remove after 5 seconds
#	await get_tree().create_timer(5.0).timeout
#	debug_sphere.queue_free()
#	debug_line.queue_free()
