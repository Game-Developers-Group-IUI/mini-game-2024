class_name PentagramArea
extends Area2D

##Child references
@export var col : CollisionPolygon2D
@export var spr : Polygon2D

##Variables
var current_ingredient : Pickup


func _ready() -> void:
	spr.modulate = Color(0,0,0,0)


func check_ingredients() -> Pickup:
	for ing in get_overlapping_bodies():
		print("body ", ing.name, ing.collision_layer)
		if ing is Pickup:
			if ing.landed:
				if not ing.PA:
					if current_ingredient != ing:
						if current_ingredient is Pickup:
							current_ingredient.consume()
						current_ingredient = ing
						current_ingredient.PA = self
						pass
	
	if current_ingredient: 
		if current_ingredient.is_queued_for_deletion():
			current_ingredient = null
	
		if current_ingredient is Pickup:
			if !current_ingredient.landed:
				current_ingredient.PA = null
				current_ingredient = null
		
		if current_ingredient is Pickup:
			spr.modulate = Color(current_ingredient.pickup_colors[current_ingredient.item])
		else:
			spr.modulate = Color(0,0,0,0)
	
	return current_ingredient
