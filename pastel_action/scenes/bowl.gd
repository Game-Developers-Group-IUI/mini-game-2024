class_name Bowl
extends Area2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Variables
var held_candy: Array[Pickup]


func check_ingredients() -> void:
	for ing: PhysicsBody2D in get_overlapping_bodies():
		if ing is Pickup and not ing.pickup_active:
			if ing.get_parent() == game.level.aboveground_floor:
				ing.in_bowl = true
				held_candy.append(ing)
				## Stack ingredients in a rickety tower
				ing.position = global_position\
				+ Vector2(randf_range(-(24*3) * 0.15, (24*3) * 0.15), (24*3) * 0.8)
				## Don't collide with other ingredients
				collision_mask = 4
				collision_layer = 0


func remove_candy(type:Pickup.type) -> void:
	var removed: bool = false
	for i in range(held_candy.size()):
		## Remove first matching candy
		if not removed and held_candy[i].item == type:
			removed = true
			held_candy.remove_at(i)
		## Move higher ingredients down
		elif removed:
			held_candy[i].global_position -= Vector2(0, (24*3) * 0.8)
