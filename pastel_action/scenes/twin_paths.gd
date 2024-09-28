class_name TwinPaths
extends Node2D

@export var twin_1 : Twin
@export var twin_2 : Twin
@export var twin_path_1 : Path2D
@export var twin_path_2 : Path2D

var speed := 1
var percent := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	percent += delta * speed * 0.01
	if percent > 1:
		percent - 1
	twin_1.progress_ratio = percent
	twin_2.progress_ratio = percent
	pass
