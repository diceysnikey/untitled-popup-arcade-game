extends "res://scripts/window.gd"

var pillar_mouse_tracker = {
	"Pillar1": false, "Pillar2": false, "Pillar3": false, "Pillar4":false
	}
var pillar_dragging_tracker = {
	"Pillar1": false, "Pillar2": false, "Pillar3": false, "Pillar4":false
	}
var target_tracker = {
	"Target1": false, "Target2": false, "Target3": false, "Target4": false,
}
var distance_offset = 0
	
func _setup_connections() -> void:
	for i in range(1, 5):
		var pillar_i = "Pillar" + str(i)
		get_node(pillar_i).get_child(0).mouse_entered.connect(_update_pillar_mouse_tracker.bind(pillar_i, true))
		get_node(pillar_i).get_child(0).mouse_exited.connect(_update_pillar_mouse_tracker.bind(pillar_i, false))
	for i in range(1, 5):
		var target_i = "Target" + str(i)
		get_node(target_i).get_child(0).area_entered.connect(_update_target_tracker.bind(target_i, true))
		get_node(target_i).get_child(0).area_exited.connect(_update_target_tracker.bind(target_i, false))

# Dragging/Resizing Start
func _update_pillar_mouse_tracker(pillar:String, mouse_inside_pillar:bool):
	pillar_mouse_tracker[pillar] = mouse_inside_pillar
func _pillar_dragging_logic(pillar:String) -> void:
	if Input.is_action_just_pressed("Hold_Left"):
		_set_distanceOffset(pillar)
		pillar_dragging_tracker[pillar] = true
	if Input.is_action_pressed("Hold_Left") and pillar_dragging_tracker[pillar]:
		get_node(pillar).global_position.y = clamp(get_global_mouse_position().y + distance_offset, 0, $ColorRect.size.y - 40)
		_pillar_sizing_logic(pillar)
	if Input.is_action_just_released("Hold_Left"):
		pillar_dragging_tracker[pillar] = false
func _pillar_sizing_logic(pillar:String) -> void:
	var distance_to_bottom = $ColorRect.size.y - get_node(pillar).global_position.y
	get_node(pillar).size.y = distance_to_bottom
func _call_pillar_dragging_logic() -> void:
	if pillar_mouse_tracker.find_key(true) != null or pillar_dragging_tracker.find_key(true) != null:
		if pillar_dragging_tracker.find_key(true) != null:
			_pillar_dragging_logic(pillar_dragging_tracker.find_key(true))
		else:
			_pillar_dragging_logic(pillar_mouse_tracker.find_key(true))
func _set_distanceOffset(pillar:String) -> void:
	distance_offset = get_node(pillar).global_position.y - get_global_mouse_position().y
# Dragging/Resizing End

# Target Start
func _update_target_tracker(area:Area2D, target:String, target_entered:bool) -> void:
	if area.is_in_group("PillarTargetArea"):
		target_tracker[target] = target_entered
		_change_target_color(target, target_entered)
func _setup_targets() -> void:
	for target in target_tracker:
		get_node(target).global_position.y = randi_range(0, $ColorRect.size.y - 60)
func _change_target_color(target:String, target_entered:bool) -> void:
	if target_entered:
		get_node(target).color = Color(0.157, 0.929, 0.18, 1.0)
	else:
		get_node(target).color = Color(0.157, 0.176, 0.18)
# Target End

func _check_for_win() -> void:
	var count = 0
	for target in target_tracker:
		if target_tracker[target]:
			count += 1
	if count == 4 and pillar_dragging_tracker.find_key(true) == null:
		_task_completed()
		
func _task_completed() -> void:
	$Blur.visible = true
	$Checkmark.visible = true
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(2).timeout
	self.queue_free()

func _ready() -> void:
	super._ready()
	_setup_connections()
	_setup_targets()

func _process(delta: float) -> void:
	super._process(delta)
	_call_pillar_dragging_logic()
	_check_for_win()
