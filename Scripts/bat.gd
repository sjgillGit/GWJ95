extends Area3D

var speed = 8 if Manager.mode == "explore" else 12
var facing = ""
var random = randf_range(1,4)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace witwh function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = -1 if facing == "left" else 1
	position.x += direction * speed * delta * random
	if abs(position.x) > 25:
		queue_free()
