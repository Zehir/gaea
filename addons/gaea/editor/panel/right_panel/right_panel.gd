@tool
class_name GaeaPreviewPanel
extends Control

@export var main_editor: GaeaMainEditor
@export var preview_container: GaeaPreviewContainer
@export var bottom_label: Label
@export var generation_settings_container: VBoxContainer

var generation_in_progress: bool = false

var _settings_inspector: EditorInspector


func _ready() -> void:
	if is_part_of_edited_scene() or not is_instance_valid(main_editor):
		return
	_build_inspector()


func _build_inspector() -> void:
	_settings_inspector = EditorInspector.new()
	_settings_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_settings_inspector.edit(null)
	_settings_inspector.property_edited.connect(_on_setting_updated)
	generation_settings_container.add_child(_settings_inspector)

	# Workaround until this issue is resolved : https://github.com/godotengine/godot/issues/112647
	await get_tree().create_timer(0.5).timeout
	for editor_property_vector3 in _settings_inspector.find_children("*", "EditorPropertyVector3", true, false):
		for node in editor_property_vector3.find_children("*", "EditorSpinSlider", true, false):
			if node is EditorSpinSlider:
				node.allow_lesser = false
				node.allow_greater = false


func populate(settings: GaeaPreviewGenerationSettings):
	_settings_inspector.edit(settings)


func unpopulate():
	_settings_inspector.edit(null)


func _on_output_node_traversed(_port: StringName, data: Variant, pouch: GaeaGenerationPouch) -> void:
	if data is GaeaGrid:
		#prints("_on_output_node_traversed", pouch.area.position, data.get_layer(0).get_cell_count())
		preview_container.draw_grid(data, pouch.area.position)


func unused_to_be_removed_on_button_pressed() -> void:
	if generation_in_progress:
		return
	generation_in_progress = true

	var settings: GaeaPreviewGenerationSettings = main_editor.graph_edit.graph.preview_generation_settings
	var start = Time.get_ticks_usec()
	var generated_region = AABB(Vector3.ZERO, settings.cell_size)
	var pouch: GaeaGenerationPouch = main_editor.graph_edit.get_pouch(generated_region)
	var graph: GaeaGraph = main_editor.graph_edit.graph
	var data: GaeaGrid = graph.get_output_node().execute(graph, pouch)
	var generation_duration = (Time.get_ticks_usec() - start) * 0.001
	start = Time.get_ticks_usec()
	preview_container.draw_grid(data, settings.cell_size * -0.5)
	generation_in_progress = false
	var render = (Time.get_ticks_usec() - start) * 0.001
	bottom_label.text = "Generated in %d ms, render in %d ms" % [generation_duration, render]



func _on_setting_updated(property_name: StringName):
	var settings: GaeaPreviewGenerationSettings = main_editor.graph_edit.graph.preview_generation_settings
	if property_name == &"world_size_preset" and settings.world_size_preset != GaeaPreviewGenerationSettings.WorldSizePreset.CUSTOM:
		settings.world_size = settings.property_get_revert(&"world_size")
		settings.cell_size = settings.property_get_revert(&"cell_size")
	if property_name == &"world_size" or property_name == &"cell_size":
		settings.world_size_preset = GaeaPreviewGenerationSettings.WorldSizePreset.CUSTOM

	main_editor.generation_settings_changed.emit()
