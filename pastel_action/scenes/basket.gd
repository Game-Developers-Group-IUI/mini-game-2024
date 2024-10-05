class_name Basket
extends Area2D

## Scenes
@onready var pickup_scene: PackedScene = preload("res://scenes/pickup.tscn")

## External References
@onready var game: Game = get_node(^"/root/Game")

## Int. References
@onready var sprite: Sprite2D = %Sprite

## Properties
@export var supplying_ingredient:Pickup.type


func _process(_delta: float) -> void:
	## pickup
	if Input.is_action_just_pressed(&"confirm"):
		for body: PhysicsBody2D in get_overlapping_bodies():
			if body is Player and not body.pickup_active:
				var new_ingredient: Pickup = pickup_scene.instantiate()
				game.level.basement_floor.add_child(new_ingredient)
				new_ingredient.setup(supplying_ingredient)
				new_ingredient.global_position = game.player.global_position
				new_ingredient.add_to_group(&"pickups")
				
				body.cooldown()
				body.pickup = new_ingredient
				body.pickup_active = true
				pass
