extends Node3D

@onready var coffins = [
	$Coffin1,
	$Coffin2,
	$Coffin3,
	$Coffin4,
	$Coffin5,
	$Coffin6,
	$Coffin7,
	$Coffin8,
]

var coffin_positions = [
	Vector3(-3, 0, 0),
	Vector3(0, 0, 0),
	Vector3(3, 0, 0)
]

var coffin_positions_escape = [
	Vector3(-4.5, 0, -1.5),
	Vector3(-1.5, 0, -1.5),
	Vector3( 1.5, 0, -1.5),
	Vector3( 4.5, 0, -1.5),
	
	Vector3(-4.5, 0,  1.5),
	Vector3(-1.5, 0,  1.5),
	Vector3( 1.5, 0,  1.5),
	Vector3( 4.5, 0,  1.5),
]


var coffin_slot = []
var correct_coffin = 1
var coffin_tweens = []
var swapping = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coffin_tweens.resize(8)
	
	if Manager.mode == "explore":
		coffin_slot = [0, 1, 2]
		correct_coffin = randi_range(0,2)
		for i in range(3):
			coffins[i].position = coffin_positions[i]
		for i in range(3, 8):
			coffins[i].visible = false
		
	elif Manager.mode == "escape":
		coffin_slot = [0,1,2,3,4,5,6,7]
		correct_coffin = randi_range(0,7)
		for i in range(8):
			coffins[i].position = coffin_positions_escape[i]
	
	await swap_order()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func swap_order():
	if swapping:
		print("BLOCKED", get_instance_id())
		return
	
	swapping = true
	print("SWAP START ID:", get_instance_id())
	
	
	if Manager.mode == "explore":
		for i in range(5):
			var a = randi_range(0,2)
			var choices = [0, 1, 2,]
			choices.erase(a)
			var b = choices.pick_random()
			two_swap(a,b)
			await get_tree().create_timer(0.5).timeout
	elif Manager.mode == "escape":
		for i in range(12):
			var a = randi_range(0,7)
			var choices = [0, 1, 2, 3, 4, 5, 6, 7]
			choices.erase(a)
			var b = choices.pick_random()
			choices.erase(b)
			var c = choices.pick_random()
			if i < 5: 
				two_swap(a,b)
			else: 
				three_swap(a,b,c)
			await get_tree().create_timer(0.35).timeout
	swapping = false



func two_swap(a,b):
	#
	#swap locations of two cups
	var temp = coffin_slot[a]
	coffin_slot[a] = coffin_slot[b]
	coffin_slot[b] = temp
	
	# swap correct coffin tracking
	if correct_coffin == a:
		correct_coffin = b
	elif correct_coffin == b:
		correct_coffin = a

	update_coffins()
	# animate movement




func three_swap(a,b,c):
	#swap locations of three cups
	var temp = coffin_slot[a]
	coffin_slot[a] = coffin_slot[b]
	coffin_slot[b] = coffin_slot[c]
	coffin_slot[c] = temp

	#if one of them was the correct coffin, then they will be swapped
	if correct_coffin == a:
		correct_coffin = b
	elif correct_coffin == b:
		correct_coffin = c
	elif correct_coffin == c:
		correct_coffin = a
	
	update_coffins()



func update_coffins():
	var number = 3 if Manager.mode == "explore" else 8
	var positions = coffin_positions if Manager.mode == "explore" else coffin_positions_escape
	for i in range(number):
		move_coffin(
			i,
			positions[coffin_slot[i]]
		)


func move_coffin(index, target):
	if coffin_tweens[index]:
		coffin_tweens[index].kill()
		
	var tween = create_tween()
	coffin_tweens[index] = tween
	
	tween.tween_property(
		coffins[index],
		"position",
		target,
		0.3
	).set_trans(Tween.TRANS_QUAD)
	
