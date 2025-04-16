@tool

extends GaeaGraphNodeParameter


@onready var option_button: OptionButton = %OptionButton


func _ready() -> void:
	super()

	if not is_instance_valid(resource):
		return
