@tool
class_name GaeaMultiLinkArgumentEditor
extends GaeaNumberArgumentEditor

var array_editors: Array[GaeaGraphNodeArgumentEditor] = []

func _configure() -> void:
	if is_part_of_edited_scene():
		return

	hint.set("min", max(1.0, hint.get("min", 1.0)))
	hint.set("max", min(26.0, hint.get("max", 26.0)))
	array_editors.clear()

	await super()
	
	graph_node.set_slot_enabled_left(slot_idx, false)
	
	for i in range(int(hint.get("max"))):
		var editor = graph_node.add_argument_editor(argument)
		editor.set_label_text(char(65 + i)) # 65 is A
		array_editors.append(editor)


func _on_spin_box_value_changed(value: float) -> void:
	super(value)

	for i in range(0, value):
		array_editors[i].visible = true
		graph_node.set_slot_enabled_left(array_editors[i].slot_idx, true)

	for i in range(value, int(hint.get("max"))):
		array_editors[i].visible = false
		graph_node.set_slot_enabled_left(array_editors[i].slot_idx, false)

	graph_node.auto_shrink()
