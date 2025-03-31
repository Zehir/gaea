@tool
extends GaeaGraphNode


func initialize() -> void:
	if not is_instance_valid(resource):
		return

	title = resource.title
	resource.node = self
	for layer in generator.data.layers.size():
		_add_layer_slot(layer)


func _add_layer_slot(idx: int) -> void:
	var slot_resource: GaeaNodeSlot = GaeaNodeSlot.new()
	slot_resource.left_enabled = true
	slot_resource.left_label = "Layer %s" % idx
	slot_resource.left_type = GaeaGraphNode.SlotTypes.MAP_DATA
	slot_resource.right_enabled = false
	add_child(slot_resource.get_node())
	_connect_layer_resource_signal(idx)
	await get_tree().process_frame
	size.y = get_combined_minimum_size().y


func update_slots() -> void:
	var layer_count: int = generator.data.layers.size()
	if layer_count < get_child_count():
		for i in range(get_child_count(), layer_count, -1):
			var child: Control = get_child(i - 1)
			child.queue_free()
			await child.tree_exited
			size.y = get_combined_minimum_size().y
	elif layer_count > get_child_count():
		for i in range(get_child_count(), layer_count):
			_add_layer_slot(i)
	
	for idx in layer_count:
		_connect_layer_resource_signal(idx)


func _connect_layer_resource_signal(idx: int):
	var layer: GaeaLayer = generator.data.layers[idx]
	if not layer or not is_instance_valid(layer):
		return
	if layer.changed.is_connected(_on_layer_resource_changed):
		return

	var node: Node = get_child(idx - 1)
	var callback = _on_layer_resource_changed.bind(idx, layer)
	layer.changed.connect(callback)
	node.tree_exiting.connect(layer.changed.disconnect.bind(callback), CONNECT_ONE_SHOT)
	callback.call_deferred()

func _on_layer_resource_changed(idx: int, layer: GaeaLayer):
	var slot: Node = get_child(idx)
	if layer.resource_name:
		slot.left_label = layer.resource_name
	else:
		slot.left_label = "Layer %s" % idx
	
	if not layer.enabled:
		slot.left_label = "[color=DIM_GRAY]%s[/color] (Disabled)" % slot.left_label
