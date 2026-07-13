extends Node
var audio_muted : bool = false
var main_scene : Node
var RadioTimer : Timer
var player_name : String
var player
var chat_history : Array = []
var mouse_sensitivity := 0.5
signal chat_update

@rpc("any_peer","call_local","reliable")
func set_chat_history(history : Array):
	chat_history = history
	chat_update.emit()

func chat_history_append(message : Array):
	chat_history.append(message)
	chat_update.emit()

@rpc("any_peer","call_local","reliable")
func request_chat_history():
	set_chat_history.rpc_id(multiplayer.get_remote_sender_id(), chat_history)

func get_all_resources_in_folder(path):
	var items = []
	var dir = DirAccess.open(path)
	
	if not dir:
		push_error("Invalid dir: " + path)
		return items  # Return an empty list if the directory is invalid
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			items.merge(get_all_resources_in_folder(path + str(file_name)))
		
		if !file_name.begins_with(".") and (file_name.ends_with(".tres") or file_name.ends_with(".tscn")):
			# print('Loaded scene: ', file_name)
			var full_path = path + "/" + file_name
			# Remove .remap extension if present
			if full_path.ends_with(".remap"):
				full_path = full_path.substr(0, full_path.length() - 6)
			# print("Checking path: ", full_path)
			if ResourceLoader.exists(full_path):
				# print("Path exists: ", full_path)
				var res = ResourceLoader.load(full_path)
				if res:
					# print("Loaded resource: ", full_path)
					items.append(res)
				else:
					push_error("Failed to load resource: ", full_path)
			else:
				push_error("Resource does not exist: ", full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

	return items


func get_all_resource_names_in_folder(path) -> Array[String]:
	var items : Array[String] = []
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Invalid dir: " + path)
		return items  # Return an empty list if the directory is invalid
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			
			items.append_array(get_all_resource_names_in_folder(path + str(file_name))) # Something wrong here
		var full_path = path + "/" + file_name
		items.append(str(full_path))
		file_name = dir.get_next()
	dir.list_dir_end()
	return items

func create_timer(time : float, oneShot : bool = false) -> Timer:
	var timer = Timer.new()
	timer.autostart = false
	timer.name = 'Timer_' + str(time) + 'sec'
	add_child(timer)
	timer.wait_time = time
	timer.one_shot = oneShot
	return timer

@rpc("any_peer","call_local","reliable")
func sync_position(node : Node, authority : int) -> void:
	var synchronizer : MultiplayerSynchronizer = node.find_child('MultiplayerSynchronizer')
	if synchronizer == null:
		synchronizer = MultiplayerSynchronizer.new()
		synchronizer.name = node.name + '_MultiplayerSynchronizer'
		synchronizer.set_multiplayer_authority(authority)
		node.add_child(synchronizer)
		var config = SceneReplicationConfig.new()
		config.add_property(node.name + ':Sync_Pos')
		config.add_property(node.name + ':rotation')
		synchronizer.set_replication_config(config)

func button_sound_effect(_args = null, _args2 = null) -> void:
	SodaAudioManager.play_ui_sfx("res://Assets/click.wav").randomize_pitch(SodaSFX.PitchVariation.SUBTLE)
	

func set_ui_effect_recursive(target : Node = self) -> void:
	var children = target.get_children(true)
	for child in children:
		if child is Button:
			child.pressed.connect(button_sound_effect)
		elif child is LineEdit:
			child.editing_toggled.connect(button_sound_effect)
		elif child is TabContainer:
			child.tab_changed.connect(button_sound_effect)
		else:
			set_ui_effect_recursive(child)

func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child, arr)
	return arr
