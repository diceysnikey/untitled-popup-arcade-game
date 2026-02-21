extends Node2D

func _ready() -> void:
	add_child(preload("res://minigame_tasks/task_budget.tscn").instantiate())
