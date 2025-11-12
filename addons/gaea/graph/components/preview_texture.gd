@tool
class_name GaeaNodePreview
extends TextureRect

const RESOLUTION: Vector2i = Vector2i(64, 64)

var selected_output: StringName = &""
var node: GaeaGraphNode
var slider_container: HBoxContainer
var slider: HSlider
var slider_label: SpinBox


func _init(parent_node) -> void:
	node = parent_node


func _ready() -> void:
	if is_part_of_edited_scene():
		return

	expand_mode = EXPAND_FIT_HEIGHT_PROPORTIONAL
	stretch_mode = STRETCH_KEEP_ASPECT

	await get_tree().process_frame

	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	slider_container = HBoxContainer.new()

	slider_label = SpinBox.new()
	slider_label.step = 0.01
	slider_label.min_value = 0.0
	slider_label.max_value = 1.0

	slider = HSlider.new()
	slider.step = 0.001
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider_label.value_changed.connect(slider.set_value_no_signal)
	slider_label.value_changed.connect(update.unbind(1))
	slider.value_changed.connect(update.unbind(1))
	slider.value_changed.connect(slider_label.set_value_no_signal)
	slider.allow_greater = true
	slider.allow_lesser = true

	slider_label.allow_greater = true
	slider_label.allow_lesser = true

	slider_container.add_child(slider)
	slider_container.add_child(slider_label)

	get_parent().add_child(slider_container)

	node.graph_edit.main_editor.generation_settings_changed.connect(update)

	var preview_resolution = node.graph_edit.main_editor.settings.cell_size
	texture = ImageTexture.create_from_image(Image.create_empty(preview_resolution.x, preview_resolution.y, false, Image.FORMAT_RGBA8))

func toggle(for_output: StringName) -> void:
	if not get_parent().visible:
		get_parent().show()
		slider_container.visible = (
			node.resource.get_output_port_type(for_output) == GaeaValue.Type.SAMPLE
		)
		selected_output = for_output
		update()
	else:
		if selected_output == for_output:
			selected_output = &""
		get_parent().hide()

	node.auto_shrink.call_deferred()


func _get_simulation_size() -> Vector3i:
	if true:
		return node.graph_edit.main_editor.settings.world_size
	match (node.resource._get_preview_simulation_size()):
		GaeaNodeResource.SimSize.WORLD:
			return node.graph_edit.main_editor.settings.world_size
		_: # GaeaNodeReousrce.SimSize.Preview is the default
			return node.graph_edit.main_editor.settings.cell_size


func update() -> void:
	if not is_visible_in_tree():
		return

	prints("update", node.resource.id)
	var sim_size: Vector3i = _get_simulation_size()
	var pouch: GaeaGenerationPouch = GaeaGenerationPouch.new(node.graph_edit.main_editor.settings, AABB(Vector3.ZERO, sim_size))
	var data: GaeaValue.GridType = node.resource.traverse(
		selected_output,
		node.graph_edit.graph,
		pouch
	).get("value")

	if is_instance_valid(data):
		prints("data", data.get_cell_count(), sim_size)
	else:
		prints("wtf y a rien")


	if not is_instance_valid(data):
		texture = null
		return

	var sim_center: Vector3i = sim_size * 0.5
	var res_center: Vector3i = Vector3i(sim_size.x, sim_size.y, 0) * 0.5
	var sim_offset: Vector3i = sim_center.max(res_center) - sim_center.min(res_center)

	var image: Image = Image.create_empty(sim_size.x, sim_size.y, false, Image.FORMAT_RGBA8)
	for x: int in sim_size.x:
		for y: int in sim_size.y:
			var color: Color
			var value = data.get_cell(Vector3i(x, y, 0) + sim_offset)
			if value == null:
				continue
			match node.resource.get_output_port_type(selected_output):
				GaeaValue.Type.SAMPLE:
					if typeof(value) != TYPE_FLOAT or is_nan(value):
						continue
					color = Color(value, value, value, 1.0 if value >= slider.value else 0.0)
				GaeaValue.Type.MAP:
					if value is not GaeaMaterial or not is_instance_valid(value):
						continue
					color = value.preview_color
				_:
					continue
			image.set_pixelv(Vector2i(x, y), color)
	texture = ImageTexture.create_from_image(image)
