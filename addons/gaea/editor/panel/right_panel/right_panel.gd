@tool
class_name GaeaPreviewPanel
extends Control

@export var main_editor: GaeaMainEditor
@export var preview_container: GaeaPreviewContainer
@export var bottom_label: Label
@export var bottom_container: VBoxContainer

var generation_in_progress: bool = false


func _on_output_node_traversed(_port: StringName, data: Variant, pouch: GaeaGenerationPouch) -> void:
	if data is GaeaGrid:
		#prints("_on_output_node_traversed", pouch.area.position, data.get_layer(0).get_cell_count())
		preview_container.draw_grid(data, pouch.area.position)


func unused_to_be_removed_on_button_pressed() -> void:
	if generation_in_progress:
		return
	generation_in_progress = true

	#var start = Time.get_ticks_usec()
	#var generated_region = AABB(Vector3.ZERO, settings.cell_size)
	#var pouch: GaeaGenerationPouch = main_editor.graph_edit.get_pouch(generated_region)
	#var graph: GaeaGraph = main_editor.graph_edit.graph
	#var data: GaeaGrid = graph.get_output_node().execute(graph, pouch)
	#var generation_duration = (Time.get_ticks_usec() - start) * 0.001
	#start = Time.get_ticks_usec()
	#preview_container.draw_grid(data, settings.cell_size * -0.5)
	#generation_in_progress = false
	#var render = (Time.get_ticks_usec() - start) * 0.001
	#bottom_label.text = "Generated in %d ms, render in %d ms" % [generation_duration, render]
