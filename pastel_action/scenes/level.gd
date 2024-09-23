extends Node2D

class_name Level

##Internal References
@export_category("Basement")
@export var basementFloor: Sprite2D
@export var pentagram: Sprite2D

@export_category("Aboveground")
@export var abovegroundFloor: Sprite2D

@export_category("Universal")
@export var walls: StaticBody2D
@export var ladder: Area2D

## Variables
@export var inBasement := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	##Ladder climb
	if Input.is_action_just_pressed("confirm"):
		for body in ladder.get_overlapping_bodies():
			#print("hi")
			if body.is_in_group("player"):
				inBasement = not inBasement
	
	
	
	
	##Switch floors
	#TODO: switching active states of interactibles that don't exist yet
	if inBasement:
		if abovegroundFloor.visible:
			abovegroundFloor.hide()
		if not basementFloor.visible:
			basementFloor.show()
	else:
		if basementFloor.visible:
			basementFloor.hide()
		if not abovegroundFloor.visible:
			abovegroundFloor.show()
	
	pass
