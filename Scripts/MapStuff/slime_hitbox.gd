extends Area3D

signal escape_reset




func _on_body_entered(body: Node3D) -> void:
	print("detectd")
	if body.is_in_group("player"):
		escape_reset.emit()
		print("Fail")
