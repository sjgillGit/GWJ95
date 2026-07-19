extends Node3D

func _ready():
	get_window().grab_focus()


#TODO: Goal logic
func _on_player_goal_ball_entered(body: Node3D) -> void:
	if body.is_in_group('Ball'):
		print('Skeleton scored 1 point')
	reset_game()


func _on_opponent_goal_ball_entered(body: Node3D) -> void:
	if body.is_in_group('Ball'):
		print('Player scored 1 point')
	reset_game()

func reset_game():
	pass
