extends CharacterBody3D
var ball : CharacterBody3D
@export_category('Movement')
@export var acceleration_curve : Curve
@export var acceleration : float = 20
@export var max_acceleration : float = 50
@export var min_acceleration : float = 20
@export var max_speed : float = 20
@export var max_speed_modifier : Curve

var walk_vel : Vector3 = Vector3.ZERO
# Gravity
var grav_vel : Vector3 = Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	ball = get_tree().get_nodes_in_group('Ball')[0]


func _process(delta: float) -> void:
	velocity = _walk(delta) + _gravity(delta)
	move_and_slide()


func _walk(delta: float) -> Vector3:
	var target = Vector3(ball.global_position.x, global_position.y, global_position.z)
	var direction = global_position.direction_to(target).normalized()
	var distance = global_position.distance_to(target)
	
	walk_vel = walk_vel.move_toward(max_speed * direction * max_speed_modifier.sample(distance), acceleration * acceleration_curve.sample(distance) * delta)
	return walk_vel
	
func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel
