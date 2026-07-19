extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(Manager.current_enemy)
	if Manager.setting == "arena" and Manager.current_enemy == "vampire":
		self.current = true
	else: 
		self.current = false
