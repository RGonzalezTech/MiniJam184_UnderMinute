class_name WingUI
extends Control

## Jump Manager to render for
@export var jump_manager_path : NodePath = ""
var _jump_manager : PlayerJumpManager

func _ready() -> void:
	_jump_manager = get_node_or_null(jump_manager_path)
	
	assert(_jump_manager, "WingUI: Missing Jump Manager")
	
	_jump_manager.jumps_changed.connect(_on_jump_update)
	_render_wings(_jump_manager.available_jumps)

func _on_jump_update(new_jumps: int) -> void:
	_render_wings(new_jumps)

## Displays 1 UI child PER available jump
func _render_wings(jump_count: int) -> void:
	var all_wings := get_children()
	for index in range(all_wings.size()):
		var element = all_wings[index]
		element.visible = index < jump_count
