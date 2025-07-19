## Blood Particle

extends Area3D

# Movement
var velocity : Vector3 = Vector3(
	randf_range(-3.0, 3.0),
	randf_range(0.5, 3.0),
	randf_range(-3.0, 3.0)
)

var is_colliding: bool = false
var do_wobble: bool = false
#var max_count: int = int(randf_range(10, 50)) # randf_range returns float
var max_count: float = randf_range(10.0, 50.0)
var count: int = 0
var lifetime: float = 0.0
var max_lifetime: float = 5.0
var paint_timer: float = 0.0
var paint_interval: float = 0.1
var last_paint_point: Vector3 = Vector3.ZERO
var current_collision_normal: Vector3 = Vector3.UP


func _ready() -> void:
	monitorable = true
	monitoring = true
#	body_entered.connect(_on_body_entered)
#	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	lifetime += delta
	paint_timer += delta
	HandleBloodMovement(delta)

	# Do a downward ray every frame if not colliding yet
	if not is_colliding:
		var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var down_ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
			global_position,
			global_position - Vector3.UP * 0.2
		)
		down_ray.collide_with_areas = true
		down_ray.collide_with_bodies = true
		down_ray.exclude = [self]
		var result: Dictionary = space.intersect_ray(down_ray)

		if result:
			is_colliding = true
			do_wobble = true
			last_paint_point = result.position
			current_collision_normal = result.normal
			Surface.draw_blood(result.position, result.normal)

			var chance: float = randf()

			if chance < 0.2:
				var splash_vector: Vector3 = result.normal * randf_range(0.3, 0.6)
				splash_vector += Vector3(
					randf_range(-0.2, 0.2),
					randf_range(-0.1, 0.1),
					randf_range(-0.2, 0.2)
				)
				velocity = splash_vector.normalized() * randf_range(5.0, 8.0)

			elif chance < 0.9:
				var splash_vector: Vector3 = -result.normal * randf_range(0.6, 1.2)
				splash_vector += Vector3(
					randf_range(-0.5, 0.5),
					randf_range(-0.2, 0.2),
					randf_range(-0.5, 0.5)
				)
				velocity = splash_vector.normalized() * randf_range(8.0, 14.0)

			else:
				var splash_vector: Vector3 = Vector3(
					randf_range(-0.3, 0.3),
					randf_range(0.8, 1.5),
					randf_range(-0.3, 0.3)
				)
				velocity = splash_vector.normalized() * randf_range(6.0, 10.0)

	# Continuous painting while on surface
	if is_colliding and paint_timer >= paint_interval:
		paint_timer = 0.0
		var paint_position: Vector3 = last_paint_point.lerp(global_position, 0.5)
		Surface.draw_blood(paint_position, current_collision_normal)
		last_paint_point = global_position

	if (
		abs(position.x) > 1000 or
		abs(position.y) > 1000 or
		abs(position.z) > 1000 or
		lifetime > max_lifetime
	):
		queue_free()


func HandleBloodMovement(delta: float) -> void:
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
