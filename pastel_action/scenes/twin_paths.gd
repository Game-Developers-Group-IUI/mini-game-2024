class_name TwinPaths
extends Node2D

## External References
@onready var game: Game = get_node(^"/root/Game")

@export var twin_1 : Twin
@export var twin_2 : Twin
@export var twin_path_1 : Path2D
@export var twin_path_2 : Path2D

var speed := 1
var percent := 0.0


func _process(delta: float) -> void:
	## Halt all processing if game is paused or viewing book
	if game.ui == game.state.paused or game.ui == game.state.running_menu:
		return
	
	percent += delta * speed * 0.01
	if percent > 1:
		percent -= 1
	twin_1.progress_ratio = percent
	twin_2.progress_ratio = percent
