extends Area3D


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		Manager.slime_caught()
