extends CharacterBody2D
var direction

func _ready() -> void:
	direction = randi_range(0, 1)*2 - 1

func _physics_process(delta: float) -> void:
	velocity = Vector2(direction,0)*200 * delta
	
