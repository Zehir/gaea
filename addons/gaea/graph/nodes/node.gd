@tool
class_name GaeaGraphNode
extends GraphNode


const PreviewTexture = preload("res://addons/gaea/graph/nodes/preview_texture.gd")
const PREVIEW_TYPES := [SlotTypes.MAP, SlotTypes.DATA]

enum SlotTypes {
	DATA,
	MAP,
	MATERIAL,
	VECTOR2,
	NUMBER,
	RANGE,
	BOOL,
	VECTOR3,
	GRADIENT,
	NULL = -1
}

signal save_requested
signal connections_updated

@export var resource: GaeaNodeResource

static var titlebar_styleboxes: Dictionary[SlotTypes, Dictionary]
var generator: GaeaGenerator
## List of connections that goes to this node from other nodes.
## Used by the generator during runtime. This list is updated
## from Panel.update_connections method.
var connections: Array[Dictionary]
var preview: PreviewTexture
var preview_container: VBoxContainer
var finished_loading: bool = false


func _ready() -> void:
	initialize()

	if is_instance_valid(resource):
		set_tooltip_text(GaeaNodeResource.get_formatted_text(resource.description))

	connections_updated.connect(_update_arguments_visibility)


func initialize() -> void:
	if not is_instance_valid(resource) or is_part_of_edited_scene():
		return

	var preview_button_group: ButtonGroup = ButtonGroup.new()
	preview_button_group.allow_unpress = true

	if resource.salt == 0:
		resource.salt = randi()

	var idx: int = 0

	for input_slot in resource.input_slots:
		if not input_slot.left_enabled:
			push_error("For input slot '%s' the left slot must be enabled." % input_slot.left_label)
		if input_slot.left_type == GaeaGraphNode.SlotTypes.NULL:
			push_error("For input slot '%s' the type must be defined." % input_slot.left_label)
		input_slot.right_enabled = false
		input_slot.right_type = GaeaGraphNode.SlotTypes.NULL
		add_child(input_slot.get_node(self, idx))
		idx += 1

	for arg in resource.args:
		add_child(arg.get_arg_node(self, idx))
		idx += 1

	for output_slot in resource.output_slots:
		output_slot.left_enabled = false
		output_slot.left_type = GaeaGraphNode.SlotTypes.NULL
		if not output_slot.right_enabled:
			push_error("For output slot '%s' the right slot must be enabled." % output_slot.right_label)
		if output_slot.right_type == GaeaGraphNode.SlotTypes.NULL:
			push_error("For output slot '%s' the type must be defined." % output_slot.right_label)
		var node: Control = output_slot.get_node(self, idx)
		idx += 1
		add_child(node)
		if output_slot.right_type in PREVIEW_TYPES:
			node.toggle_preview_button.show()

			if not is_instance_valid(preview):
				preview_container = VBoxContainer.new()
				preview = PreviewTexture.new()
				preview.node = self
				preview.resource = resource
				generator.generation_finished.connect(preview.update.unbind(1))

			var output_idx = resource.output_slots.find(output_slot) + resource.args.filter(_has_output_slot).size()
			node.toggle_preview_button.button_group = preview_button_group
			node.toggle_preview_button.toggled.connect(preview.toggle.bind(output_idx, output_slot.right_type).unbind(1))

	if is_instance_valid(preview_container):
		add_child(preview_container)
		preview_container.add_child(preview)
		preview_container.hide()
	title = resource.title
	resource.node = self

	var output_type: SlotTypes = resource.get_type()
	var titlebar: StyleBoxFlat
	var titlebar_selected: StyleBoxFlat
	if output_type != SlotTypes.NULL:
		if not titlebar_styleboxes.has(output_type) or titlebar_styleboxes.get(output_type).get("for_color", Color.TRANSPARENT) != resource.get_title_color():
			titlebar = get_theme_stylebox("titlebar", "GraphNode").duplicate()
			titlebar_selected = get_theme_stylebox("titlebar_selected", "GraphNode").duplicate()
			titlebar.bg_color = titlebar.bg_color.blend(Color(resource.get_title_color(), 0.3))
			titlebar_selected.bg_color = titlebar.bg_color
			titlebar_styleboxes.set(output_type, {"titlebar": titlebar, "selected": titlebar_selected, "for_color": resource.get_title_color()})
		else:
			titlebar = titlebar_styleboxes.get(output_type).get("titlebar")
			titlebar_selected = titlebar_styleboxes.get(output_type).get("selected")
		add_theme_stylebox_override("titlebar", titlebar)
		add_theme_stylebox_override("titlebar_selected", titlebar_selected)



func _has_output_slot(arg: GaeaNodeArgument) -> bool:
	return arg.add_output_slot


func on_added() -> void:
	pass


func get_connected_node(connection_idx: int) -> GraphNode:
	for connection in connections:
		if connection.to_port == connection_idx:
			return get_parent().get_node(NodePath(connection.from_node))
	return null


func get_connected_port(connection_idx: int) -> int:
	for connection in connections:
		if connection.to_port == connection_idx:
			return connection.from_port
	return -1


func get_arg_value(arg_name: String) -> Variant:
	for child in get_children():
		if child is GaeaGraphNodeParameter:
			if child.resource.name == arg_name:
				return child.get_param_value()
	return null


func set_arg_value(arg_name: String, value: Variant) -> void:
	for child in get_children():
		if child is GaeaGraphNodeParameter:
			if child.resource.name == arg_name:
				child.set_param_value(value)
				return


func _on_param_value_changed(_value: Variant, _node: GaeaGraphNodeParameter, _param_name: String) -> void:
	if finished_loading:
		save_requested.emit()
		if is_instance_valid(preview):
			preview.update()


func _update_arguments_visibility() -> void:
	var input_idx: int = -1
	for child in get_children():
		if is_slot_enabled_left(child.get_index()):
			input_idx += 1

		if child is GaeaGraphNodeParameter:
			child.set_param_visible(not connections.any(_is_connected_to.bind(input_idx)))

	size.y = get_combined_minimum_size().y
	for i: int in get_child_count():
		slot_updated.emit.call_deferred(i)


func on_removed() -> void:
	pass


func request_save() -> void:
	save_requested.emit()


func notify_connections_updated() -> void:
	connections_updated.emit()


func _is_connected_to(connection: Dictionary, idx: int) -> bool:
	return connection.to_port == idx and connection.to_node == name


func get_save_data() -> Dictionary:
	var dictionary: Dictionary = {
		"name": name,
		"position": position_offset,
		"salt": resource.salt
	}
	if resource.args.size() > 0:
		dictionary.set("data", {})
		for arg in resource.args:
			var value: Variant = get_arg_value(arg.name)
			if value == null:
				continue
			if value != arg.get_default_value():
				dictionary.data[arg.name] = get_arg_value(arg.name)
	return dictionary


func load_save_data(saved_data: Dictionary) -> void:
	position_offset = saved_data.position
	if saved_data.has("data"):
		var data = saved_data.get("data")
		for child in get_children():
			if child is GaeaGraphNodeParameter:
				if not data.has(child.resource.name):
					data.set(child.resource.name, child.get_param_value())

				if data.get(child.resource.name) != null:
					child.set_param_value(data[child.resource.name])

	finished_loading = true


static func get_color_from_type(type: SlotTypes) -> Color:
	match type:
		SlotTypes.DATA:
			return Color("f0f8ff") # WHITE
		SlotTypes.MAP:
			return Color("27ae60") # GREEN
		SlotTypes.MATERIAL:
			return Color("eb2f06") # RED
		SlotTypes.VECTOR2:
			return Color("00bfff") # LIGHT BLUE
		SlotTypes.VECTOR3:
			return Color("8e44ad") # MAGENTA
		SlotTypes.NUMBER:
			return Color("a0a0a0") # GRAY
		SlotTypes.RANGE:
			return Color("f04c7f") # PINK
		SlotTypes.BOOL:
			return Color("ffdd59") # YELLOW
		SlotTypes.GRADIENT:
			return Color("4834d4") # BLURPLE
		#SlotTypes.TEXTURE: # Reserved Orange for later use.
		#	return Color("e67e22")
	return Color.WHITE


static func get_icon_from_type(type: SlotTypes) -> Texture2D:
	match type:
		SlotTypes.RANGE:
			return load("res://addons/gaea/assets/slots/ring.svg")
		SlotTypes.BOOL:
			return load("res://addons/gaea/assets/slots/rounded_square.svg")
		SlotTypes.DATA:
			return load("res://addons/gaea/assets/slots/square.svg")
		SlotTypes.MAP:
			return load("res://addons/gaea/assets/slots/tag.svg")
		SlotTypes.MATERIAL:
			return load("res://addons/gaea/assets/slots/rhombus.svg")
		SlotTypes.VECTOR3:
			return load("res://addons/gaea/assets/slots/hourglass.svg")
		SlotTypes.VECTOR2:
			return load("res://addons/gaea/assets/slots/triangle.svg")
		SlotTypes.GRADIENT:
			return load("res://addons/gaea/assets/slots/diamond.svg")

	return load("res://addons/gaea/assets/slots/circle.svg")


func _make_custom_tooltip(for_text: String) -> Object:
	var rich_text_label: RichTextLabel = RichTextLabel.new()
	rich_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD

	rich_text_label.bbcode_enabled = true
	rich_text_label.text = for_text
	rich_text_label.fit_content = true
	rich_text_label.custom_minimum_size.x = 256.0
	return rich_text_label
