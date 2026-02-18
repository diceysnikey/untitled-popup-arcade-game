extends Node2D

func _ready() -> void:
	add_child(preload("res://scenes/window.tscn").instantiate())
