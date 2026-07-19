extends Control
enum Menus {HIDDEN = -1, START_MENU = 0, SETTINGS_MENU}
var active_menu = 0
@onready var mouse_sensitivity_slider: HSlider = %MouseSensitivitySlider
@onready var input_map: GridContainer = %InputMap

signal game_starting

func _ready():
	show()
	init_controls()
	active_menu = Menus.START_MENU
	update_menu()
	Global.set_ui_effect_recursive(self)

func _on_play_pressed() -> void:
	game_starting.emit()

func begin_game() -> void:
	var scene = load("res://Main/main_gameplay.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	update_menu()


func _on_settings_pressed() -> void:
	active_menu = Menus.SETTINGS_MENU
	update_menu()

func _on_quit_pressed() -> void:
	if multiplayer.is_server():
		multiplayer.get_multiplayer_peer().close()
	get_tree().quit()

func update_menu() -> void:
	for child in get_children(true):
		child.visible = false
	if active_menu == -1:
		hide()
		return
	get_child(active_menu).visible = true

func back_to_main():
	active_menu = Menus.START_MENU
	for child in get_children(true):
		child.visible = false
	update_menu()

func close_menu():
	active_menu = Menus.HIDDEN
	update_menu()

func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	if value <= -49.0:
		if !AudioServer.is_bus_mute(0):
			AudioServer.set_bus_mute(0,true)
	elif AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0,false)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index('SFX')
	AudioServer.set_bus_volume_db(bus, value)
	if value <= -49.0:
		if !AudioServer.is_bus_mute(bus):
			AudioServer.set_bus_mute(bus,true)
	elif AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus,false)

func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
	Global.mouse_sensitivity = value

func _on_mouse_sensitivity_slider_drag_ended(_value_changed: bool) -> void:
	print_debug('Mouse sensitivity set: ', Global.mouse_sensitivity)

func init_controls(): # Controls set up
	mouse_sensitivity_slider.value = Global.mouse_sensitivity
	for event in InputMap.get_actions():
		if event.split('_')[0] != 'ui' and event.split('_')[-1] != 'hidden':
			var new_label = Label.new()
			new_label.name = event + '_label'
			new_label.text = event
			input_map.add_child(new_label)
			
			var new_linedit = LineEdit.new()
			new_linedit.name = event
			new_linedit.text = InputMap.action_get_events(event)[0].as_text().split('(')[0]
			# Bind signals
			new_linedit.focus_entered.connect(_on_control_focus_entered)
			new_linedit.gui_input.connect(_on_control_gui_input)
			input_map.add_child(new_linedit)


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var input_field = get_viewport().gui_get_focus_owner()
		input_field.text = event.as_text_key_label()
		input_field.release_focus()
		InputMap.action_erase_events(input_field.name)
		InputMap.action_add_event(input_field.name, event)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_control_focus_entered() -> void:
	var text_field : LineEdit = get_viewport().gui_get_focus_owner()
	text_field.text = 'Waiting...'
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta: float) -> void:
	pass
