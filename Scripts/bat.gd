extends Area3D

var speed = 8
var facing = "left"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = -1 if facing == "left" else 1
	position.x += direction * speed * delta
	if abs(position.x) > 25:
		queue_free()
