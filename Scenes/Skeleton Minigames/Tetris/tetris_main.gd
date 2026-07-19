extends Node3D

@export var hardcore := true
var water_timer : float = -15.0 # before water starts rising
var time_to_escape : float = 60.0 # before water reaches the top
var lost := false
var blocks_path : String = "res://Scenes/Skeleton Minigames/Tetris/blocks/"
var blocks  := []
var blocks_queue := []
var block_held : RigidBody3D = null
var block_prev : RigidBody3D = null :
	set(value):
		if !value:
			new_block_dropped = false
		else:
			new_block_dropped = true
		block_prev = value
var new_block_dropped := false
@onready var tetris: Node3D = $"."
@onready var geometry: StaticBody3D = $Geometry

@onready var tetris_player: Tetris_player = $TetrisPlayer
@onready var spawn_point: Marker3D = $Geometry/SpawnPoint
@onready var timer_aiming = Global.create_timer(2, true)
@onready var timer_spawn = Global.create_timer(4, true)

@export var moving_force : float = 40000
@export var tutorials : Dictionary[String, RigidBody3D]

@onready var skeleton_game: Node3D = $".."
@onready var camera_3d: Camera3D = $Camera3D
@onready var cutscene_manager: Node3D = $"../../CutsceneManager"


func _ready() -> void:
	$Water.mesh.material.set_shader_parameter('dissolve_height', -1.0)
	timer_spawn.timeout.connect(spawn_block)
	timer_aiming.timeout.connect(drop_block)
	get_window().grab_focus()
	blocks = Global.get_all_resources_in_folder(blocks_path)
	reshuffle_blocks()


func start_game():
	lost = false
	water_timer = -15.0
	camera_3d.make_current()
	# Difficulty
	if Manager.mode == "explore":
		hardcore = false
		time_to_escape = 90.0
	else: # escape
		hardcore = true
		time_to_escape = 60.0

	spawn_block()

func _physics_process(delta: float) -> void:
	aim(delta)
	if !tutorials.is_empty():
		tutorial()
	if hardcore: hardcore_mode(delta)

func reshuffle_blocks():
	seed(Time.get_ticks_msec())
	blocks_queue = blocks.duplicate()
	blocks_queue.shuffle()

func spawn_block():
	if lost: return
	var block = blocks_queue.pop_front().instantiate()
	geometry.add_child(block)
	block.transform = spawn_point.transform
	if blocks_queue.is_empty():
		reshuffle_blocks()
	block_held = block
	block_held.axis_lock_linear_y = true
	timer_aiming.start()
	timer_spawn.start()

func drop_block():
	if block_prev:
		block_prev.linear_damp = 2.0
		block_prev.angular_damp = 5.0
	block_held.axis_lock_linear_y = false
	block_held.angular_damp = 1.0
	block_held.apply_central_force(Vector3.DOWN*40000)
	block_held.gravity_scale = 3.0
	
	block_held.linear_velocity.z *= 0.5

	
	block_prev = block_held
	block_held = null

func aim(delta):
	if !block_held:
		return

	var target = Vector3(global_position.x, global_position.y, tetris_player.global_position.z)
	var direction = block_held.global_position.direction_to(target).normalized()
	var distance = min(block_held.global_position.distance_to(target), 8.0)

	block_held.apply_central_force(direction * moving_force * distance * delta * 3)


			
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SHIFT and new_block_dropped:
			block_prev.apply_central_force(Vector3.DOWN*25000)
			new_block_dropped = false
			

func tutorial():
	pass
	#if hardcore:
		#for tut in tutorials:
			#tutorials[tut].visible = false
	#if Input.is_action_pressed("Sprint") and tutorials.has('TutorialSHIFT'):
		#tutorials['TutorialSHIFT'].apply_central_force(Vector3.DOWN*25000)
		#tutorials.erase('TutorialSHIFT')
	#if (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")) and tutorials.has('TutorialAD'):
		#tutorials['TutorialAD'].apply_central_force(Vector3.DOWN*25000)
		#tutorials.erase('TutorialAD')
	#if Input.is_action_pressed("Interact") and tutorials.has('TutorialPUSH'):
		#tutorials['TutorialPUSH'].apply_central_force(Vector3.DOWN*25000)
		#tutorials.erase('TutorialPUSH')
	#if Input.is_action_pressed("Jump") and tutorials.has('TutorialJump'):
		#tutorials['TutorialJump'].apply_central_force(Vector3.DOWN*25000)
		#tutorials.erase('TutorialJump')

func hardcore_mode(delta:float):
	if lost: return
	water_timer += delta
	var water_level = clamp(water_timer/time_to_escape, 0.0, 1.0)
	$Water.mesh.material.set_shader_parameter('dissolve_height', water_level)
	if tetris_player.global_position.y+7 < water_level*100:
		level_fail()

#TODO: logic for level failure
func level_fail():
	lost = true
	print('Lost')

#TODO: logic for level victory
func _on_escape_body_entered(body: Node3D) -> void:
	if lost:
		return

	if body.is_in_group("Player"):
		lost = true

		timer_spawn.stop()
		timer_aiming.stop()

		print("Victory")

		hide()
		cutscene_manager.skeleton_cutscene_fishing_1()
