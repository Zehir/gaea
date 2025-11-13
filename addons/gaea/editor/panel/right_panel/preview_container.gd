@tool
extends SubViewportContainer

@export var target_world_3d: World3D
@export var view_port: SubViewport
@export var object_3d: Node3D
@export var camera: Camera3D


func _ready() -> void:
	if is_part_of_edited_scene():
		return

	view_port.world_3d = target_world_3d

	pass
	#await resized
	#get_parent().split_offset = int(size.x)


func _gui_input(event: InputEvent) -> void:
	camera.input(event)
