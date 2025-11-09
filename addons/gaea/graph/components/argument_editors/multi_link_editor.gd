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
		graph_node.set_argument_editor_visible(arguments[i], true)

	for i in range(value, hint.get("max")):
		graph_node.set_argument_editor_visible(arguments[i], false)

	graph_node.auto_shrink()
