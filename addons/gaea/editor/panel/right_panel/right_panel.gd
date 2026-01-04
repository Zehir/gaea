@tool
class_name GaeaPreviewPanel
extends Control

const GENERATION_TOOLTIP: String = "Press generate to see result"

@export var main_editor: GaeaMainEditor
@export var preview_container: GaeaPreviewContainer
@export var bottom_label: Label
@export var bottom_container: VBoxContainer
@export var generate_button: Button
@export var directional_light_1: DirectionalLight3D

var generation_in_progress: bool = false

var _task_pool: GaeaTaskPool

func _on_light_1_toggled(toggled_on: bool) -> void:
	directional_light_1.visible = toggled_on


func _on_generate_button_pressed() -> void:
	if generation_in_progress:
		return
	generate_button.disabled = true
	generation_in_progress = true

	if _task_pool == null:
		_task_pool = GaeaTaskPool.new()
		_task_pool.task_finished.connect(_execution_task_finished)
		_task_pool.task_limit = 1

	preview_container.clear_grid()
	var graph: GaeaGraph = main_editor.graph_edit.graph
	var area = AABB(Vector3.ZERO, graph.preview_chunk_size)
	var settings: GaeaGenerationSettings = GaeaGenerationSettings.new()
	settings.cell_size = graph.preview_chunk_size
	settings.world_size = graph.preview_chunk_size
	settings.random_seed_on_generate = false
	settings.seed = graph.preview_seed

	var pouch: GaeaGenerationPouch = GaeaGenerationPouch.new(settings, area)

	var task: GaeaGenerationTask = GaeaGenerationTask.new(
		"Execute on %s" % area,
		graph,
		pouch,
	)

	_task_pool.queue(task)


func _execution_task_finished(task: GaeaTask):
	var graph: GaeaGraph = main_editor.graph_edit.graph
	var area = AABB(Vector3.ZERO, graph.preview_chunk_size)
	var exec: GaeaGenerationTask = task as GaeaGenerationTask
	var data: GaeaGrid = exec.results

	preview_container.draw_grid(data, graph.preview_chunk_size * -0.5, area, graph.preview_coordinate_format)
	if bottom_label.text == GENERATION_TOOLTIP:
		preview_container.reset_camera_view()
	# TODO change this with ms instead of second (this require the task pool class to use Time.get_ticks_usec()).
	bottom_label.text = "Generated in %d s" % (task.finish_time - task.run_time)

	generation_in_progress = false
	generate_button.disabled = false


func reset() -> void:
	_task_pool = null
	preview_container.clear_grid()
	preview_container.reset_camera_view()
	bottom_label.text = GENERATION_TOOLTIP
