@tool
extends Camera3D

# External var
@export var scroll_speed: float = 10 # Speed when use scroll mouse
@export var zoom_speed: float = 5 # Speed use when is_zoom_in or is_zoom_out is true
@export var default_distance: float = 20 # Default distance of the Node
@export var rotate_speed: float = 10
@export var anchor_node_path: NodePath

# Use to add posibility to updated zoom with external script
var is_zoom_in: bool
var is_zoom_out: bool

# Event var
var _move_speed: Vector2
var _scroll_speed: float

# Transform var
var _rotation: Vector3
var _distance: float
var _anchor_node: Node3D

func _ready():
	_distance = default_distance
	_anchor_node = self.get_node(anchor_node_path)
	_rotation = _anchor_node.transform.basis.get_rotation_quaternion().get_euler()

func _process(delta: float):
	if is_zoom_in:
		_scroll_speed = -1 * zoom_speed
	if is_zoom_out:
		_scroll_speed = 1 * zoom_speed
	_process_transformation(delta)

func _process_transformation(delta: float):
	# Update rotation
	_rotation.x += -_move_speed.y * delta * rotate_speed
	_rotation.y += -_move_speed.x * delta * rotate_speed
	if _rotation.x < -PI/2:
		_rotation.x = -PI/2
	if _rotation.x > PI/2:
		_rotation.x = PI/2
	_move_speed = Vector2()

	# Update distance
	_distance += _scroll_speed * delta
	if _distance < 0:
		_distance = 0
	_scroll_speed = 0

	self.set_identity()
	self.translate_object_local(Vector3(0,0,_distance))
	_anchor_node.set_identity()
	_anchor_node.transform.basis = Basis(Quaternion.from_euler(_rotation))



func input(event: InputEvent):
	if event is InputEventMouseMotion:
		_process_mouse_rotation_event(event)
	elif event is InputEventMouseButton:
		_process_mouse_scroll_event(event)


func _process_mouse_rotation_event(e: InputEventMouseMotion):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_move_speed = e.relative


func _process_mouse_scroll_event(e: InputEventMouseButton):
	if e.button_index == MOUSE_BUTTON_WHEEL_UP:
		_scroll_speed = -1 * scroll_speed
	elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		_scroll_speed = 1 * scroll_speed
