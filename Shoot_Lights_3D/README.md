## Introduction

Basic Shooting Light Fixtures and Bulbs in 3D for Godot 4.3...

I don't see any tutorials on how to do this online for 3D.. so it took me a little while to figure out.

### How to Use

1. Create a **New 3D Scene**.. change the **Root Node** type from **Node3D** to **RigidBody3D**. Name it **Pot_Light** (as an example).

2. Add the Light Fixture's **MeshInstance3D** and **CollisionShape3D** as **children** of the **Root Node**.

3. Add a **RigidBody3D** as a **child** of the **Root Node**. Name it **Bulb** (as an example). Add the Bulb's **MeshInstance3D** and **CollisionShape3D** as **children** of the newly created **RigidBody3D Node**.

4. Add script **Light_Fixtures.gd** to the Root Node **RigidBody3D (Pot_Light)**.
 
5. Add script **Bulb.gd** to **RigidBody3D (Bulb)**

6. Make sure the Root Node **(Light_Fixture)** is in a **Global Group** called **Light_Fixture**.

7. Make sure the RigidBody3D **(Bulb)** is in a **Global Group** called **Light_Bulb**.

8. This last step depends **how you detect collisions**... but this is what i've got in my **init_weapons.gd**

```
func hit_scan_damage(collider: Object, _direction: Vector3, _position: Vector3, _weapon_damage: int) -> void:
	# Enemy hit
	if collider.is_in_group("Enemy") and collider.has_method("hit_successful"):
		var attacker: Node = Global.player
		collider.hit_successful(_weapon_damage, attacker)
		print("Hit Scan Damage applied to Enemy:", collider.name, collider.get_groups())

	# Light bulb hit
	elif collider.is_in_group("Light_Bulb") and collider.has_method("shatter_bulb") and collider.has_method("hit_successful"):
		collider.shatter_bulb()
		print("Hit Scan Damage applied to Light Bulb:", collider.name, collider.get_groups())

	# Light fixture hit
	elif collider.is_in_group("Light_Fixture") and collider.has_method("hit_successful"):
		collider.hit_successful(_weapon_damage)
		print("Hit Scan Damage applied to Light Fixture:", collider.name, collider.get_groups())

	# Target hit
	elif collider.is_in_group("Target") and collider.has_method("hit_successful"):
		collider.hit_successful(_weapon_damage)
		print("Hit Scan Damage applied to Target:", collider.name, collider.get_groups())
```


and this is what i've got in my **bullet.gd** script (attached to my projectile RigidBody3D)

```
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Light_Bulb") and body.has_method("shatter_bulb"):
		body.shatter_bulb()
		queue_free()
		return

	elif body.is_in_group("Light_Fixture") and body.has_method("hit_light"):
		body.hit_light(global_transform.origin)
		queue_free()
		return

	elif body.is_in_group("Enemy") and body.has_method("take_damage"):
		body.take_damage(damage, self)
		queue_free()
		return

	elif body.is_in_group("Player"):
		PlayerStats.take_damage(damage)
		queue_free()
		return

	elif body.is_in_group("Target") and body.has_method("hit_successful"):
		body.hit_successful(damage, self)
		queue_free()
		return

```

### That's it! Have fun!

![Alt text](https://github.com/mikecabral/Godot_4/blob/main/Shoot_Lights_3D/thumbnail.png)

![Alt text](https://github.com/mikecabral/Godot_4/blob/main/Shoot_Lights_3D/thumbnail2.png)