@tool
extends GaeaGenerator


func set_graph(new_graph: GaeaGraph) -> void:
	graph = new_graph
	settings = new_graph.preview_generation_settings
