@tool
class_name GaeaPreviewContainer
extends Control

@export var target_world_3d: World3D
@export var view_port: SubViewport
@export var camera: Camera3D
@export var base_mesh: Mesh
@export var container: Node3D

@export var cube_button: Button
@export var quad_button: Button
@export var light_1_button: Button
@export var light_2_button: Button
@export var checkerboard: TextureRect


var multi_mesh_instances: Dictionary[Vector3i, MultiMeshInstance3D]

func _ready() -> void:
	if is_part_of_edited_scene():
		return

	view_port.world_3d = target_world_3d
	container.add_child(build_axis_mesh())
	cube_button.icon = get_theme_icon(&"MaterialPreviewCube", &"EditorIcons")
	quad_button.icon = get_theme_icon(&"MaterialPreviewQuad", &"EditorIcons")
	checkerboard.texture = get_theme_icon(&"Checkerboard", &"EditorIcons")
	light_1_button.icon = get_theme_icon(&"MaterialPreviewLight1", &"EditorIcons")


func _gui_input(event: InputEvent) -> void:
	camera.input(event)


func clear_grid():
	for multi_mesh: MultiMeshInstance3D in multi_mesh_instances.values():
		multi_mesh.multimesh.instance_count = 0


func draw_grid(grid: GaeaGrid, offset: Vector3i):
	if false:
		print("no render")
		return
	var multimesh: MultiMesh
	if multi_mesh_instances.has(offset):
		multimesh = multi_mesh_instances.get(offset).multimesh
	else:
		var new_instance = MultiMeshInstance3D.new()
		multimesh = MultiMesh.new()
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.use_colors = true
		multimesh.mesh = base_mesh
		new_instance.multimesh = multimesh
		multi_mesh_instances.set(offset, new_instance)
		container.call_deferred(&"add_child", new_instance)

	var instance_idx = -1
	var instance_count: int = 0
	for layer_idx in grid.get_layers_count():
		instance_count += grid.get_layer(layer_idx).get_cell_count()

	multimesh.instance_count = instance_count

	for layer_idx in grid.get_layers_count():
		var layer: GaeaValue.Map = grid.get_layer(layer_idx)

		for cell in layer.get_cells():
			instance_idx += 1
			multimesh.set_instance_transform(instance_idx, Transform3D(Basis(), cell))
			multimesh.set_instance_color(instance_idx, layer.get_cell(cell).preview_color)


func build_axis_mesh() -> MeshInstance3D:
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var mesh := ImmediateMesh.new()

	# Materials (unshaded)
	var mat_x := StandardMaterial3D.new()
	mat_x.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat_x.albedo_color = Color.RED

	var mat_y := StandardMaterial3D.new()
	mat_y.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat_y.albedo_color = Color.GREEN

	var mat_z := StandardMaterial3D.new()
	mat_z.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat_z.albedo_color = Color.BLUE

	# AXES (lines)
	_draw_axis(mesh, mat_x, Vector3.RIGHT)
	_draw_axis(mesh, mat_y, Vector3.UP)
	_draw_axis(mesh, mat_z, Vector3.BACK)

	mesh_instance.mesh = mesh
	return mesh_instance


func _draw_axis(mesh: ImmediateMesh, mat: Material, dir: Vector3):
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, mat)
	mesh.surface_add_vertex(Vector3.ZERO)
	mesh.surface_add_vertex(dir * 500.0)
	mesh.surface_end()
