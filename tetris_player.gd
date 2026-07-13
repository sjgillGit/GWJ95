class_name Tetris_player extends CharacterBody3D

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 20 # m/s
@export_range(10, 400, 1) var acceleration: float = 50 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 5.2 # m

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity


func _ready() -> void:
	capture_mouse()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"): jumping = true
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _walk(delta: float) -> Vector3:
	walk_vel.z = velocity.z
	move_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	walk_vel.z = walk_vel.move_toward(Vector3(0, 0, -move_dir.x) * speed, acceleration * delta).z
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		jumping = false
		if is_on_floor(): 
			jump_vel = Vector3(0, sqrt(7 * jump_height * gravity), 0)
			return jump_vel
	if is_on_floor():
		jump_vel = Vector3.ZERO
		return jump_vel
	if Input.is_action_pressed("Jump") and jump_vel.y > 0:
		jump_vel = jump_vel.move_toward(Vector3.ZERO, gravity * 2 * delta)
	elif !Input.is_action_pressed("Jump") and jump_vel.y > 0:
		jump_vel = jump_vel.move_toward(Vector3.ZERO, gravity * 4 * delta)
	else:
		jump_vel = jump_vel.move_toward(Vector3(0,-15,0), gravity * 10 * delta)
	return jump_vel
