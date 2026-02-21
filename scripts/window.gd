extends Node2D

var mouse_inside = false
var dragging = false
var mouse_distance_offset:Vector2

func _mouse_entered_area() -> void:
	mouse_inside = true
func _mouse_exited_area() -> void:
	mouse_inside = false
func _set_mouse_distance_offset() -> void:
	mouse_distance_offset = global_position - get_global_mouse_position()

func _ready() -> void:
	$Area2D.mouse_entered.connect(_mouse_entered_area)
	$Area2D.mouse_exited.connect(_mouse_exited_area)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hold_Left") and mouse_inside:
		dragging = true
		_set_mouse_distance_offset()
	if Input.is_action_pressed("Hold_Left") and dragging:
		global_position = get_global_mouse_position() + mouse_distance_offset
	if Input.is_action_just_released("Hold_Left"):
		dragging = false
