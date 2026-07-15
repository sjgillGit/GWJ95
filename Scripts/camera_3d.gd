extends Camera3D

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	# Center of the screen
	var screen_center = get_viewport().get_visible_rect().size / 2

	# Create a ray from the camera through the center pixel
	var ray_origin = project_ray_origin(screen_center)
	var ray_direction = project_ray_normal(screen_center)

	var ray_length = 1000.0

	var query = PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_origin + ray_direction * ray_length
	)

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		var collider = result.collider

		print("Hit:", collider.name)

		# If it's an Area3D
		if collider is Area3D:
			print("Hit an Area3D!")

			# Call a function on it
			if collider.has_method("is_hit"):
				collider.is_hit()
