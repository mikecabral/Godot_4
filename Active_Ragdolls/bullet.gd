extends RigidBody3D
# Bullet.gd
signal hit_detected(hit_body: Node)

var attacker = null
var damage: int = 1
var speed: float = 20.0
var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	name = "Player"
	gravity_scale = 1
	$Timer.start()

	if direction != Vector3.ZERO:
		linear_velocity = direction * speed
	else:
		linear_velocity = transform.basis.z * -speed


func _find_damage_receiver(node: Node) -> Node:
	var current = node

	while current != null:
		if current.is_in_group("Enemy") and current.has_method("take_damage"):
			return current
		current = current.get_parent()

	return null

func _on_body_entered(body: Node) -> void:
	print("Bullet collision detected!")
	print("Bullet attacker: ", attacker)
	print("Hit body: ", body, " (", body.name, ")")

	# === IGNORE SELF-COLLISION ===
	if attacker != null and body == attacker:
		print("Ignored bullet hitting myself: ", body.name)
		return

	var hit_pos: Vector3 = global_transform.origin
	var hit_normal: Vector3 = -linear_velocity.normalized() if linear_velocity.length() > 0 else Vector3.UP

	print("==============================")
	print("BULLET HIT DETECTED")
	print("Hit body: ", body.name)
	print("Hit position: ", hit_pos)
	print("Hit normal: ", hit_normal)
	print("==============================")

	# --- RAGDOLL IMPACT ---
	# climb up to the Skeleton3D that holds the ragdoll script
	var skeleton_with_script := body
	while skeleton_with_script != null and not skeleton_with_script.has_method("start_temporary_simulation"):
		skeleton_with_script = skeleton_with_script.get_parent()

	if skeleton_with_script != null:
		# start the simulation
		skeleton_with_script.start_temporary_simulation()
		
		await get_tree().process_frame

		# now your existing code runs exactly as written
		if skeleton_with_script.has_method("physics_bones"):
			for b in skeleton_with_script.physics_bones:
				# Apply impulse at the bullet hit direction
				var direction = linear_velocity.normalized()
				b.apply_central_impulse(direction * 10000)  # fixed impulse, tunable


	# ===============================
	# ENEMY DAMAGE (NEW FIX)
	# ===============================
	var enemy = _find_damage_receiver(body)

	if enemy:
		print("Damage routed to:", enemy.name)
		enemy.take_damage(damage, self)
		emit_signal("hit_detected", enemy)
		queue_free()
		return


func _on_timer_timeout() -> void:
	queue_free()
