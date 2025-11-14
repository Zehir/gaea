@tool
class_name GaeaPreviewPanel
extends Control

@export var main_editor: GaeaMainEditor
@export var preview_container: GaeaPreviewContainer
@export var bottom_label: Label
@export var generation_settings_container: VBoxContainer
@export var button_2d: TextureButton
@export var button_3d: TextureButton


var _settings_inspector: EditorInspector

var _pouches: Dictionary[Vector3, GaeaGenerationPouch]
var generation_in_progress: bool = false

func _ready() -> void:
	if is_part_of_edited_scene() or not is_instance_valid(main_editor):
		return
	_build_inspector()
	button_2d.texture_normal = get_theme_icon(&"MaterialPreviewQuad", &"EditorIcons")
	button_3d.texture_normal = get_theme_icon(&"MaterialPreviewCube", &"EditorIcons")


func _on_button_pressed() -> void:
	if generation_in_progress:
		return
	generation_in_progress = true
	var start = Time.get_ticks_usec()
	var generated_region = AABB(Vector3.ZERO, main_editor.settings.cell_size)
	print(generated_region)
	var pouch: GaeaGenerationPouch = get_pouch(generated_region)
	var graph: GaeaGraph = main_editor.graph_edit.graph
	var data: GaeaGrid = graph.get_output_node().execute(graph, pouch)
	var generation_duration = (Time.get_ticks_usec() - start) * 0.001
	start = Time.get_ticks_usec()
	preview_container.draw_grid(data, main_editor.settings.cell_size * -0.5)
	generation_in_progress = false
	var render = (Time.get_ticks_usec() - start) * 0.001
	bottom_label.text = "Generated in %d ms, render in %d ms" % [generation_duration, render]

func get_pouch(generation_area: AABB) -> GaeaGenerationPouch:
	if _pouches.has(generation_area.position):
		return _pouches.get(generation_area.position)
	var pouche: GaeaGenerationPouch = GaeaGenerationPouch.new(main_editor.settings, generation_area)
	_pouches.set(generation_area.position, pouche)
	return pouche


func _build_inspector() -> void:
	_settings_inspector = EditorInspector.new()
	_settings_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_settings_inspector.edit(null)
	_settings_inspector.edit(main_editor.settings)
	_settings_inspector.property_edited.connect(_on_setting_updated)
	generation_settings_container.add_child(_settings_inspector)

	# Workaround until this issue is resolved : https://github.com/godotengine/godot/issues/112647
	await get_tree().create_timer(0.5).timeout
	for editor_property_vector3 in _settings_inspector.find_children("*", "EditorPropertyVector3", true, false):
		for node in editor_property_vector3.find_children("*", "EditorSpinSlider", true, false):
			if node is EditorSpinSlider:
				node.allow_lesser = false
				node.allow_greater = false


func _on_setting_updated(property_name: StringName):
	if property_name == &"world_size_preset" and main_editor.settings.world_size_preset != GaeaPreviewGenerationSettings.WorldSizePreset.CUSTOM:
		main_editor.settings.world_size = main_editor.settings.property_get_revert(&"world_size")
		main_editor.settings.cell_size = main_editor.settings.property_get_revert(&"cell_size")
	if property_name == &"world_size" or property_name == &"cell_size":
		main_editor.settings.world_size_preset = GaeaPreviewGenerationSettings.WorldSizePreset.CUSTOM

	_on_button_pressed()
	main_editor.generation_settings_changed.emit()
	_pouches.clear()
