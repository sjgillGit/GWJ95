extends Node2D

var floaters_in_water : Array[RigidBody2D] = []

func _ready():
	$Background/Underwater/Floater.apply_central_impulse(Vector2(1,-1)*300)

func _physics_process(delta: float) -> void:
	pass

func _on_floating_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Floater'):
		floaters_in_water.append(body)
		body.sleeping = true
		body.get_child(0).visible = true
		print('added floater')


func _on_floating_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('Floater') and floaters_in_water.has(body):
		floaters_in_water.erase(body)
		print('removed floater')
