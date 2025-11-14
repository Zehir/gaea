@tool
class_name GaeaPreviewContainer
extends SubViewportContainer

@export var target_world_3d: World3D
@export var view_port: SubViewport
@export var camera: Camera3D
@export var multi_mesh_instance: MultiMeshInstance3D

func _ready() -> void:
	if is_part_of_edited_scene():
		return

	view_port.world_3d = target_world_3d
	multi_mesh_instance.multimesh = multi_mesh_instance.multimesh.duplicate()

	#multi_mesh_instance.multimesh.instance_count = 1
	#multi_mesh_instance.multimesh.set_instance_transform(0, Transform3D(Basis(), Vector3(0.0, 0.0, 0.0)))
	#multi_mesh_instance.multimesh.set_instance_color(0, Color.BLUE)
	pass
	#await resized
	#get_parent().split_offset = int(size.x)


func _gui_input(event: InputEvent) -> void:
	camera.input(event)


func draw_grid(grid: GaeaGrid, offset: Vector3i):
	var multimesh: MultiMesh = multi_mesh_instance.multimesh
	var instance_idx = -1
	var instance_count: int = 0
	for layer_idx in grid.get_layers_count():
		instance_count += grid.get_layer(layer_idx).get_cell_count()

	multimesh.instance_count = instance_count

	for layer_idx in grid.get_layers_count():
		var layer: GaeaValue.Map = grid.get_layer(layer_idx)

		for cell in layer.get_cells():
			instance_idx += 1
			var pos = Vector3(cell.x + offset.x, cell.y, cell.z + offset.z)
			#pos.y = - pos.y
			multimesh.set_instance_transform(instance_idx, Transform3D(Basis(), pos))
			multimesh.set_instance_color(instance_idx, layer.get_cell(cell).preview_color)
