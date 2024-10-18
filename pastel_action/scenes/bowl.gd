class_name Bowl
extends Area2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Variables
var held_candy: Array[Pickup.type]
var sprites: Array[Sprite2D]


func check_ingredients(ing:Pickup) -> void:
	held_candy.append(ing.item)
	ing.queue_free()
	sprites.append(Sprite2D.new())
	## Load item texture
	sprites[-1].texture = load("res://assets/candy/" + Pickup.type.find_key(held_candy[-1]) + ".png")
	add_child(sprites[-1])
	sprites[-1].scale = Vector2.ONE * 3
	## Stack ingredients in a rickety tower
	sprites[-1].global_position = global_position\
	+ Vector2(randf_range(-(24*3) * 0.25, (24*3) * 0.25), -(24*3) * 0.5 * (held_candy.size() - 1))


func remove_candy(type:Pickup.type) -> void:
	var removed: bool = false
	for i in range(held_candy.size()):
		## Remove first matching candy
		if not removed and held_candy[i] == type:
			removed = true
			held_candy.remove_at(i)
			sprites.remove_at(i)
		## Move higher ingredients down
		elif removed:
			sprites[i].global_position -= Vector2(0, -(24*3) * 0.5 * (held_candy.size() - 1))
