@tool
extends EditorExportPlugin
class_name GaeaEditorExportPlugin


var ignore_files: Array[Resource] = [
	GaeaEditorPlugin,
]


var ignore_directory_containing: Array[Resource] = [
	GaeaEditorExportPlugin, # res://addons/gaea/editor/
	GaeaGraphNodeOutput, # res://addons/gaea/graph/components/
	load("uid://bagab60q30jx7"), # res://addons/gaea/assets/
]


var ignore_child_of: Array[GDScript] = [
	GaeaGraphNode,
	GaeaGraphFrame,
	GaeaGraphNodeArgumentEditor,
]


var _ignore_path_list: Array[String] = []


func _get_name() -> String:
	# The name should be < "GDScript" or the skips won't works.
	# See https://github.com/godotengine/godot/issues/93487.
	# Docs: "The plugins are sorted by name before exporting".
	return "GDA_Gaea"


func _export_begin(_features: PackedStringArray, _is_debug: bool, _path: String, _flags: int) -> void:
	_ignore_path_list.clear()
	for resource: Resource in ignore_files:
		_ignore_path_list.append(resource.resource_path)
	for resource: Resource in ignore_directory_containing:
		_ignore_path_list.append(resource.resource_path.get_base_dir())


func _export_file(path: String, type: String, _features: PackedStringArray) -> void:
	for ignore_path: String in _ignore_path_list:
		if path.begins_with(ignore_path):
			skip()
			return

	# For PackedScene, check the root script
	if type == "PackedScene":
		var current: SceneState = (load(path) as PackedScene).get_state()
		for prop_idx: int in range(current.get_node_property_count(0)):
			if current.get_node_property_name(0, prop_idx) == "script":
				var value: Object = current.get_node_property_value(0, prop_idx)
				if value is GDScript:
					type = "GDScript"
					path = value.resource_path
					break

	# Ignore script based on the inheritance
	if type == "GDScript":
		var current: GDScript = load(path)
		for parent: GDScript in ignore_child_of:
			if _is_child_of(current, parent):
				skip()
				return


func _is_child_of(script: GDScript, parent: GDScript) -> bool:
	if script == parent:
		return true
	var base: Script = script.get_base_script()
	if base is GDScript:
		return _is_child_of(base, parent)
	return false


func _export_end() -> void:
	_ignore_path_list.clear()
