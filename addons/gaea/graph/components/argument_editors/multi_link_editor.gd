@tool
class_name GaeaMultiLinkArgumentEditor
extends GaeaNumberArgumentEditor

var arguments: Array[GaeaGraphNodeArgumentEditor] = []
var argument_prefix: StringName

func _configure() -> void:
	if is_part_of_edited_scene():
		return
	var parts = argument.split("/")
	argument_prefix = "/".join(parts.slice(0, 2))
	set_label_text(("%s count" % parts[1].capitalize()))
	hint.set("min", max(1.0, hint.get("min", 1.0)))
	hint.set("max", min(26.0, hint.get("max", 26.0)))

	await super()


func _on_spin_box_value_changed(value: float) -> void:
	super(value)
	if arguments.size() == 0:
		return
	for i in range(0, value):
		arguments[i].visible = true
		graph_node.set_slot_enabled_left(arguments[i].slot_idx, true)

	for i in range(value, hint.get("max")):
		arguments[i].visible = false
		graph_node.set_slot_enabled_left(arguments[i].slot_idx, false)

	graph_node.auto_shrink()
