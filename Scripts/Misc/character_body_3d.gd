extends CharacterBody3D

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 20 # m/s
@export_range(10, 400, 1) var acceleration: float = 50 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 5.2 # m

@onready var area = $Area3D


var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var can_interact = true
var stop_movement = true







func _ready() -> void:
	capture_mouse()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"): jumping = true
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	#push(delta)
	if Input.is_action_pressed("Interact") and can_interact == true: 
		interact()
	if Input.is_action_pressed("ui_cancel"): 
		release_mouse()
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _walk(delta):
	if stop_movement:
		walk_vel = walk_vel.move_toward(Vector3.ZERO, acceleration * delta)
		return walk_vel
	move_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = Vector3(
		move_dir.x,
		0,
		move_dir.y
	)
	walk_vel = walk_vel.move_toward(
		direction * speed,
		acceleration * delta
	)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	#maybe remove
	if Manager.setting == "map":
		jumping = false
		if is_on_floor():
			jump_vel = Vector3.ZERO
		return jump_vel
		
	if stop_movement:
		jumping = false
		if is_on_floor():
			jump_vel = Vector3.ZERO
		return jump_vel
	
	
	
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


func interact():
	var target = get_closest_body()
	print(target)
	if target != null and target.has_method("interacted"):
		target.interacted()
	can_interact = false
	await get_tree().create_timer(0.5).timeout
	can_interact = true


func get_closest_body():
	var objects = area.get_overlapping_bodies()
	var closest_body = null
	var closest_distance = INF
	
	for body in objects:
		var distance = global_position.distance_to(body.global_position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_body = body
	
	return closest_body


#func push(delta):
	#if !Input.is_action_pressed('Interact'): return
	#
	#$GrabRay.target_position = Vector3(0, 0, move_dir.x*2)
	#var collider = $GrabRay.get_collider()
	#var floor_collider = $FloorCollider.get_collider()
	#if (collider and collider is RigidBody3D) and (floor_collider and floor_collider != collider):
		#collider.apply_central_force(Vector3(0, 0, move_dir.x)*35000*delta)
