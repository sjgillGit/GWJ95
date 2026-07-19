extends Area3D

signal escape_reset

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		escape_reset.emit()
