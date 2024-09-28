class_name TwinPaths
extends Node2D

@export var Twin1 : Twin
@export var Twin2 : Twin
@export var TwinPath1 : Path2D
@export var TwinPath2 : Path2D

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
	Twin1.progress_ratio = percent
	Twin2.progress_ratio = percent
	pass
