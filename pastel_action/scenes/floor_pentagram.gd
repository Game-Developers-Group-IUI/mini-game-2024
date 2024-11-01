class_name FloorPentagram
extends Node2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Scenes
@onready var pickup_scene: PackedScene = preload("res://scenes/pickup.tscn")

## Static References
@export var pieces: Array

## Variables
var recipes: Array[Recipe]


func _ready() -> void:
	load_recipes()


func _process(_delta: float) -> void:
	for a: PentagramArea in get_children():
		a.check_ingredients()


func craft() -> void:
	## Check each recipe
	for recipe: Recipe in recipes:
		var matching_slots: int = 0
		## Check each slot of the pentagram
		for i: int in range(get_child_count()):
			var slot_number: int = get_child(i).slot_number
			var slot_index: int = slot_number - 1
			## If slot is empty, check if recipe's slot is also empty
			if get_child(i).current_ingredient == null:
				if recipe.slots[slot_index] == Pickup.type.EMPTY:
					matching_slots += 1
			## If slot isn't empty, check if it matches recipe's slot
			if get_child(i).current_ingredient != null\
			and get_child(i).current_ingredient.item == recipe.slots[slot_index]:
				matching_slots += 1
		## If all slots match with the recipe
		if matching_slots == 11 and recipe.output != Pickup.type.EMPTY:
			## Delete the ingredients
			for i: int in range(get_child_count()):
				if is_instance_valid(get_child(i).current_ingredient):
					get_child(i).delete_ingredient()
			## Spawn the result
			var candy: Pickup = pickup_scene.instantiate()
			game.level.basement_floor.add_child(candy)
			candy.setup(recipe.output)
			candy.global_position = global_position
			candy.poof_effect.restart()
			candy.add_to_group(&"pickups")
			## Don't check further recipes
			break


func load_recipes() -> void:
	recipes.append(load("res://recipes/test.tres"))
	recipes.append(load("res://recipes/black_death_licorice.tres"))
	recipes.append(load("res://recipes/boiling_blood_chew.tres"))
	recipes.append(load("res://recipes/chemically_treated_toffee.tres"))
	recipes.append(load("res://recipes/fright_white_chocolate.tres"))
	recipes.append(load("res://recipes/mycelial_truffle_treats.tres"))
	recipes.append(load("res://recipes/prickly_peppermint.tres"))
	recipes.append(load("res://recipes/sour_sickle_pops.tres"))
	recipes.append(load("res://recipes/strawberry_milk.tres"))
	recipes.append(load("res://recipes/surreal_cider_shot.tres"))
	recipes.append(load("res://recipes/wriggling_worms_o_chewing.tres"))
	for recipe: Recipe in recipes:
		recipe.setup()
