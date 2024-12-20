class_name PentagramArea
extends Area2D

## External References
@onready var game: Game = get_node(^"/root/Game")

##Child references
@export var col : CollisionPolygon2D
@export var spr : Polygon2D

## Variables
var current_ingredient : Pickup


func _ready() -> void:
	spr.modulate = Color(0,0,0,0)


func check_ingredients() -> Pickup:
	for ing in get_overlapping_bodies():
		if ing is Pickup and ing.landed and not ing.penta_area:
			if ing.get_parent() == game.level.basement_floor and\
			(ing.item == Pickup.type.cackling_caramel or ing.item == Pickup.type.crimson_cane\
			or ing.item == Pickup.type.spooky_milk or ing.item == Pickup.type.plague_syrup):
				if current_ingredient != ing:
					if current_ingredient is Pickup:
						current_ingredient.consume()
					current_ingredient = ing
					current_ingredient.penta_area = self
	
	if current_ingredient: 
		if current_ingredient.is_queued_for_deletion():
			current_ingredient = null
	
		if current_ingredient is Pickup:
			if !current_ingredient.landed:
				current_ingredient.penta_area = null
				current_ingredient = null
		
		if current_ingredient is Pickup:
			spr.modulate = Color(current_ingredient.pickup_colors[current_ingredient.item])
		else:
			spr.modulate = Color(0,0,0,0)
	
	return current_ingredient
