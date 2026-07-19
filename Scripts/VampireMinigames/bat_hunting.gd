extends Area3D

var speed = 8
var facing = "left"

var vertical_speed = 0
var flip_cooldown = false



func _process(delta: float) -> void:
	var direction = -1 if facing == "left" else 1
	
	position.x += direction * speed * delta
	position.z += -1 * vertical_speed * delta
	
	vertical_speed = move_toward(vertical_speed, 0, 5 * delta)

	if abs(position.z) > 15:
		queue_free()

	if position.x > 10:
		facing = "left"
		vertical_speed = 5
		
	elif position.x < -10:
		facing = "right"
		vertical_speed = 5


func is_hit():
	pass
