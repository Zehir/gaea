@tool
class_name GaeaPreviewPanel
extends Control

@export var main_editor: GaeaMainEditor
@export var preview_container: GaeaPreviewContainer
@export var bottom_label: Label
@export var bottom_container: VBoxContainer
@export var generate_button: Button
@export var directional_light_1: DirectionalLight3D

var generation_in_progress: bool = false


func _on_light_1_toggled(toggled_on: bool) -> void:
	directional_light_1.visible = toggled_on


func _on_generate_button_pressed() -> void:
	if generation_in_progress:
		return
	generate_button.disabled = true
	generation_in_progress = true

	var start = Time.get_ticks_usec()
	var graph: GaeaGraph = main_editor.graph_edit.graph
	var area = AABB(Vector3.ZERO, graph.preview_chunk_size)
	var settings: GaeaGenerationSettings = GaeaGenerationSettings.new()
	settings.cell_size = graph.preview_chunk_size
	settings.world_size = graph.preview_chunk_size
	settings.random_seed_on_generate = false
	settings.seed = graph.preview_seed

	var pouch: GaeaGenerationPouch = GaeaGenerationPouch.new(settings, area)
	var data: GaeaGrid = graph.get_output_node().execute(graph, pouch)
	preview_container.draw_grid(data, settings.cell_size * -0.5)
	bottom_label.text = "Generated in %d ms" % ((Time.get_ticks_usec() - start) * 0.001)

	generation_in_progress = false
	generate_button.disabled = false
