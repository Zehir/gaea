@tool
extends SubViewportContainer

@export var target_world_3d: World3D
@export var view_port: SubViewport

func _init() -> void:
	if not is_part_of_edited_scene():
		view_port.world_3d = target_world_3d
