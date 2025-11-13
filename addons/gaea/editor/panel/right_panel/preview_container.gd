@tool
extends SubViewportContainer

@export var target_world_3d: World3D
@export var view_port: SubViewport
@export var camera: Camera3D
@export var multi_mesh_instance: MultiMeshInstance3D

func _ready() -> void:
	if is_part_of_edited_scene():
		return

	view_port.world_3d = target_world_3d

	multi_mesh_instance.multimesh.instance_count = 1
	multi_mesh_instance.multimesh.set_instance_transform(0, Transform3D(Basis(), Vector3(0.0, 0.0, 0.0)))
	multi_mesh_instance.multimesh.set_instance_color(0, Color.BLUE)
	pass
	#await resized
	#get_parent().split_offset = int(size.x)


func _gui_input(event: InputEvent) -> void:
	camera.input(event)
