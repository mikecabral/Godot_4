## Blood Particle

extends Area3D

# Movement
var velocity := Vector3(
	randf_range(-3.0, 3.0),
	randf_range(0.5, 3.0),  # Y (always positive, but less extreme)
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
	
	# Continuous painting while on surface
	if is_colliding && paint_timer >= paint_interval:
		paint_timer = 0.0
		
		# Calculate paint position along the movement path
		var paint_position = last_paint_point.lerp(global_position, 0.5)
		
		# Paint blood smear
		Surface.draw_blood(paint_position, current_collision_normal)
		last_paint_point = global_position
		
		# Debug visualization
#		_debug_draw_collision(paint_position, current_collision_normal)
	
	if (abs(position.x) > 1000 or 
		abs(position.y) > 1000 or 
		abs(position.z) > 1000 or
		lifetime > max_lifetime):
		queue_free()

func HandleBloodMovement(delta: float):
	if !is_colliding:
		# Simple constant gravity acceleration
		velocity.y -= 9.8 * delta
		
		# Air drag
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
	print("Collided with: ", body.name)
	print("Body layers: ", body.collision_layer)
	
	if !is_colliding:
		is_colliding = true
		do_wobble = true
		last_paint_point = global_position
		
		# UNIVERSAL COLLISION HANDLING
		var collision_point = global_position
		current_collision_normal = Vector3.UP
		
		# Get collision data
		var space = get_world_3d().direct_space_state
		var ray = PhysicsRayQueryParameters3D.create(
			global_position + velocity.normalized() * 0.1,
			global_position - velocity.normalized() * 0.1
		)
		ray.collide_with_areas = true
		ray.collide_with_bodies = true
		ray.exclude = [self]
		var result = space.intersect_ray(ray)
		
		if result:
			collision_point = result.position
			current_collision_normal = result.normal
		else:
			# Handle StaticBody3D specifically
			if body is StaticBody3D:
				var down_ray = PhysicsRayQueryParameters3D.create(
					global_position + Vector3.UP * 0.5,
					global_position - Vector3.UP * 2.0
				)
				down_ray.exclude = [self]
				var down_result = space.intersect_ray(down_ray)
				if down_result:
					collision_point = down_result.position
					current_collision_normal = down_result.normal
		
		# Initial paint at impact point
		Surface.draw_blood(collision_point, current_collision_normal)
		
		# Debug visualization
#		_debug_draw_collision(collision_point, current_collision_normal)
		
		# Calculate splash direction
		var splash_vector = -current_collision_normal * randf_range(0.3, 0.6)
		splash_vector += Vector3(
			randf_range(-0.5, 0.5),
			randf_range(0.1, 0.3),
			randf_range(-0.5, 0.5)
		) * velocity.length()
		
		# Apply splash effect
		velocity = splash_vector.normalized() * velocity.length() * 0.5

#####

func _on_body_exited(body: Node3D):
	is_colliding = false
	do_wobble = false

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
