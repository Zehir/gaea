@tool
class_name GaeaGraphNodeOutput
extends MarginContainer
## An output slot inside a [GaeaGraphNode].

## Reference to the [GaeaGraphNode] instance
var graph_node: GaeaGraphNode
## Index of the slot in the [GaeaGraphNode].
var slot_idx: int
var type: GaeaValue.Type

@onready var _label: RichTextLabel = %RightLabel
@onready var _toggle_preview_button: TextureButton = %TogglePreviewButton:
	get = get_toggle_preview_button


## Sets the corresponding variables.
func initialize(
	for_graph_node: GaeaGraphNode, for_type: GaeaValue.Type, display_name: String
) -> void:
	graph_node = for_graph_node
	type = for_type
	_label.text = display_name
	update_input_slot_index(get_editor_index())
	_configure()


func _configure() -> void:
	if is_part_of_edited_scene():
		return

	if not graph_node.is_node_ready():
		await graph_node.ready

	_toggle_preview_button.texture_normal = get_theme_icon(&"GuiVisibilityHidden", &"EditorIcons")
	_toggle_preview_button.texture_pressed = get_theme_icon(&"GuiVisibilityVisible", &"EditorIcons")
	_toggle_preview_button.toggle_mode = true


func update_input_slot_index(new_index: int) -> void:
	prints("update_input_slot_index", new_index)
	slot_idx = new_index
	if slot_idx == -1:
		return

	#graph_node.clear_all_slots()

	#if false:
	#	graph_node.set_slot_enabled_left(0, false)
	#	graph_node.set_slot_enabled_left(1, false)
	#	graph_node.set_slot_enabled_left(2, false)
	#	graph_node.set_slot_enabled_left(3, false)
	#	graph_node.set_slot_enabled_left(4, false)
	#	graph_node.set_slot_enabled_left(5, false)

	#graph_node.set_slot_enabled_left(6, true)
	#graph_node.set_slot_color_left(6, Color.BLUE)
	#graph_node.set_slot_custom_icon_left(6, GaeaValue.get_slot_icon(GaeaValue.Type.RANGE))

	#print("set blue")

	graph_node.set_slot_enabled_right(slot_idx, true)
	graph_node.set_slot_type_right(slot_idx, type)
	graph_node.set_slot_color_right(slot_idx, GaeaValue.get_color(type))

	# I have really no idea why this offset is needed but for some reason it's only required for the icon on the right side.
	#var invisible_count: int = -1
	#for child in graph_node.get_children():
	#	if not child.visible:
	#		invisible_count += 1
	#graph_node.set_slot_custom_icon_right(slot_idx - invisible_count, GaeaValue.get_slot_icon(type))
	graph_node.set_slot_custom_icon_right(slot_idx, GaeaValue.get_slot_icon(type))



## Returns the button used to toggle the preview for this output slot.
func get_toggle_preview_button() -> TextureButton:
	return _toggle_preview_button



func get_editor_index() -> int:
	var index: int = -1
	if not visible:
		return index
	for child in graph_node.get_children():
		if child.visible:
			index += 1
		if child == self:
			return index
	return -1
