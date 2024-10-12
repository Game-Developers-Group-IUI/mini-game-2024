class_name FloorPentagram
extends Node2D

@export var pieces : Array


func _process(_delta: float) -> void:
	for a : PentagramArea in get_children():
		a.check_ingredients()
