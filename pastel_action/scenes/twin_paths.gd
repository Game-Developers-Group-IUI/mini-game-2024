class_name TwinPaths
extends Node2D

@export var twin_1 : Twin
@export var twin_2 : Twin
@export var twin_path_1 : Path2D
@export var twin_path_2 : Path2D

var speed := 1
var percent := 0.0


func _process(delta: float) -> void:
	percent += delta * speed * 0.01
	if percent > 1:
		percent -= 1
	twin_1.progress_ratio = percent
	twin_2.progress_ratio = percent
