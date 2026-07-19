extends Node3D

const SPEED = 10


@onready var doors =[
	$Door1,
	$Door2,
	$Door3,
	
	$Door4,
	$Door5,
	$Door6,
	
	$Door7,
	$Door8,
	$Door9
]

var door_positions = [
	Vector3(-3, 0, -20),
	Vector3(0, 0, -20),
	Vector3(3, 0, -20),
	
	Vector3(-3, 0, -10),
	Vector3(0, 0, -10),
	Vector3(3, 0, -10),
	
	Vector3(-3, 0, 0),
	Vector3(0, 0, 0),
	Vector3(3, 0, 0)
]

var all_symbols = [
	"circle",
	"triangle",
	"square",
	"star",
	"heart"
]

var symbols_list = []
var current_symbol

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	generate_symbols()
	current_symbol = symbols_list[0]

	
	for door in doors:
		door.door_entered.connect(_on_door_entered)
	for i in range(doors.size()):
		doors[i].position = door_positions[i]
		

	
	for i in range(3):
		var row_doors = [0, 1, 2]
		var row_symbols = all_symbols.duplicate()

		# Pick the correct door in this row
		var correct_index = row_doors.pick_random()
		var correct_door = correct_index + i * 3

		# Assign correct symbol
		doors[correct_door].symbol = symbols_list[i]

		# Remove used door and used symbol
		row_doors.erase(correct_index)
		row_symbols.erase(symbols_list[i])

		# Assign the two fake symbols
		for door_index in row_doors:
			var fake_symbol = row_symbols.pick_random()
			doors[door_index + i * 3].symbol = fake_symbol
			row_symbols.erase(fake_symbol)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for door in doors:
		door.position +=Vector3(0,0, SPEED * delta)



func generate_symbols():
	for i in range(3):
		symbols_list.append(all_symbols[randi_range(0,4)])

	

func show_sign():
	pass
	#will add once I have the assets and stuff, this should display
	#the symbols in symbols_list for a few seconds if it is the explore phase

func _on_door_entered(door):
	if door.symbol != current_symbol:
		pass
		#lose condition
	else: 
		door.open()
		
func open():
	$CollisionShape3D.disabled = true
