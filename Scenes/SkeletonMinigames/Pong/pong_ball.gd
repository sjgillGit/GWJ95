extends CharacterBody3D

@export var speed : float = 10.0
var direction = Vector3.ZERO
var hit_count : int = 0

func _ready():
	direction.z = 1
	
	direction = direction.normalized()
	velocity = direction


func _process(delta: float) -> void:
	var collision : KinematicCollision3D = move_and_collide(velocity)
	direction = direction.normalized()
	if collision:
		var surface_normal = collision.get_normal()
		direction = bounce(direction, surface_normal).normalized()
	velocity = direction * (speed + hit_count) * delta


func bounce(bouncing_vector: Vector3, normal: Vector3) -> Vector3:
	return -2*(normal.dot(bouncing_vector))*normal + bouncing_vector
	
