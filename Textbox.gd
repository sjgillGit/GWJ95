extends Node2D

@onready var label: RichTextLabel = $Sprite2D/RichTextLabel

var text_speed := 0.03

func _ready():
	hide()

func display_text(text: String):
	# Show the textbox
	show()

	# Set font size and color
	label.add_theme_font_size_override("normal_font_size", 32)
	label.add_theme_color_override("default_color", Color.BLACK)

	label.text = text
	label.visible_characters = 0

	# Typewriter effect
	for i in text.length():
		label.visible_characters = i + 1
		await get_tree().create_timer(text_speed).timeout


func hide_text():
	hide()
