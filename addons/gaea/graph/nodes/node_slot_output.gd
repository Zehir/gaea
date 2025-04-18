@tool
class_name GaeaNodeSlotOutput extends GaeaNodeSlot


@export var name: StringName = &"":
	set(new_value):
		name = new_value
		if not resource_path.ends_with(".tres"):
			resource_name = new_value.capitalize()
@export var type: GaeaValue.Type = GaeaValue.Type.FLOAT:
	set(new_value):
		type = new_value
		notify_property_list_changed()


func get_node(_graph_node: GaeaGraphNode, _idx: int) -> Control:
	var node: GaeaGraphNodeOutput = preload("uid://cqpby5jyv71l0").instantiate()
	node.resource = self
	node.initialize(_graph_node, _idx)
	return node
