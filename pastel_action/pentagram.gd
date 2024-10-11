class_name Pentagram
extends Node

##external references
@export var book : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


func check_recipes() -> bool:
	##Check over all currently available recipe resources inside of the book node and see if the current placed ingredients match any of them
	return true
	pass
