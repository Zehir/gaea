extends Node2D

@onready var gaea_generator: GaeaGenerator = $GaeaGenerator

func _on_button_pressed() -> void:
	gaea_generator.generate()
