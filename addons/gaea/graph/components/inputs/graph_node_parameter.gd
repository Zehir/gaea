@tool
class_name GaeaGraphNodeParameter
extends Control

@export var add_input_slot: bool = true
@export var input_type: GaeaValue.Type
@export var connection_idx: int = 0

var add_output_slot: bool = false
var resource: GaeaNodeSlotParam
## Reference to the [GaeaGraphNode] instance
var graph_node: GaeaGraphNode
## ID of the slot in the [GaeaGraphNode].
var slot_idx: int

signal param_value_changed(new_value: Variant)

@onready var label: Label = $Label


func initialize(_graph_node: GaeaGraphNode, _slot_idx: int) -> void:
	graph_node = _graph_node
	slot_idx = _slot_idx


func _ready() -> void:
	if is_part_of_edited_scene():
		return

	if resource.default_value != null:
		set_param_value(resource.default_value)

	if not graph_node.is_node_ready():
		await graph_node.ready

	param_value_changed.connect(graph_node._on_param_value_changed.bind(self, resource.name))

	graph_node.set_slot(
		slot_idx,
		add_input_slot, input_type, GaeaValue.get_color(input_type),
		add_output_slot, input_type, GaeaValue.get_color(input_type),
		GaeaValue.get_slot_icon(input_type),
		GaeaValue.get_slot_icon(input_type),
	)

	set_label_text(resource.name.capitalize())


func get_param_value() -> Variant:
	return null


func set_param_value(_new_value: Variant) -> void:
	pass


func set_label_text(new_text: String) -> void:
	label.text = new_text


func get_label_text() -> String:
	return label.text


func set_param_visible(value: bool) -> void:
	for child in get_children():
		if child == label:
			continue
		child.set_visible(value)
