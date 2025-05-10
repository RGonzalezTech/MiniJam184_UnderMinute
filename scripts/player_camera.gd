class_name PlayerCamera
extends Camera3D

# Mouse sensitivity (adjust to your preference)
@export var mouse_sensitivity = 0.002 # Radians per pixel

# Max look up/down angle in degrees
@export var max_look_up_angle = 75.0
@export var min_look_down_angle = -45.0

## Node3D responsible for turning camera
@export var cam_turn_rig : NodePath = ""

## Node3D responsible for pitching camera
@export var cam_pitch_rig : NodePath = ""

var _cam_turn_rig_node : Node3D = null
var _cam_pitch_rig_node : Node3D = null

func _ready() -> void:
	_cam_turn_rig_node = get_node_or_null(cam_turn_rig)
	_cam_pitch_rig_node = get_node_or_null(cam_pitch_rig)
	
	# Validate
	assert(_cam_turn_rig_node)
	assert(_cam_pitch_rig_node)
	
	# Capture the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	# Handle mouse look
	if event is InputEventMouseMotion:
		if _cam_turn_rig_node:
			# Rotate CamRig around its Y-axis for horizontal (yaw) look
			_cam_turn_rig_node.rotate_y(-event.relative.x * mouse_sensitivity)
		
		if _cam_pitch_rig_node:
			# Rotate CamPitchRig around its X-axis for vertical (pitch) look
			_cam_pitch_rig_node.rotate_x(-event.relative.y * mouse_sensitivity)
			# Clamp the pitch of CamPitchRig
			_cam_pitch_rig_node.rotation.x = clamp(_cam_pitch_rig_node.rotation.x, deg_to_rad(min_look_down_angle), deg_to_rad(max_look_up_angle))

	# Toggle mouse capture with Escape key
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
