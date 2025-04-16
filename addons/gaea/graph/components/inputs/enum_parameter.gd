@tool

extends GaeaGraphNodeParameter


@onready var option_button: OptionButton = %OptionButton


func _ready() -> void:
	super()

	if not is_instance_valid(resource):
		return

	var options_key = resource.name.capitalize()
	var options = graph_node.resource.get(options_key)
	if typeof(options) != TYPE_DICTIONARY:
		var script = graph_node.resource.get_script()
		if script is Script:
			push_error("Could not find Enum named '%s' in script %s." % [options_key , script.get_path()])
		else:
			push_error("Could not find Enum named '%s' in node resource script." % options_key)
		return
	
	for option in options:
		option_button.add_item(option, options.get(option))

	option_button.item_selected.connect(param_value_changed.emit)


func get_param_value() -> int:
	if super() != null:
		return super()
	return option_button.get_selected_id()


func set_param_value(new_value: Variant) -> void:
	if typeof(new_value) != TYPE_INT:
		return
	option_button.select(new_value)
	param_value_changed.emit(new_value)
