extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(9.5).timeout
	Manager.setting = "map"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Manager.setting == "map":
		self.current = true
	else: 
		self.current = false
