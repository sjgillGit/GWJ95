extends Node2D

signal fish_attempt(success: bool)

@onready var areaof_good: Sprite2D = $AreaofGood
@onready var moving_arrow: Sprite2D = $MovingArrow


var speed := 600.0
var direction := 1
var moving := false
var good_area_size := 100.0


func start():
	moving = true
	reset()


func stop():
	moving = false


func set_difficulty(new_speed: float, new_size: float):
	speed = new_speed
	good_area_size = new_size


func _process(delta):
	if !moving:
		return

	moving_arrow.position.y += speed * delta * direction

	if moving_arrow.position.y >= 640:
		direction = -1

	if moving_arrow.position.y <= -640:
		direction = 1


func _input(event):
	if event.is_action_pressed("Interact") and moving:
		check_fish()


func check_fish():
	moving = false

	var success = abs(
		moving_arrow.position.y - areaof_good.position.y
	) <= good_area_size

	fish_attempt.emit(success)


func reset():
	moving_arrow.position.y = randf_range(-500, 500)
	areaof_good.position.y = randf_range(-540, 540)
	direction = 1
