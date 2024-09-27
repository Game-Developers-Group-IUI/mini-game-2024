class_name Basket
extends Area2D

## Ext. references
@export var ingredient: PackedScene
@export var pickup_holder: Node2D
@export var texture_source: CompressedTexture2D

## Int. References
@onready var sprite: Sprite2D = %Sprite

func _ready()-> void:
	sprite.texture = texture_source

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## pickup
	if Input.is_action_just_pressed(&"confirm"):
		for body: PhysicsBody2D in get_overlapping_bodies():
			if body is Player and not body.pickup_active:
				var new_ingredient: Pickup = ingredient.instantiate()
				
				new_ingredient.position = position
				new_ingredient.pickup_active = true
				pickup_holder.add_child(new_ingredient)
				
				body.cooldown()
				body.pickup = new_ingredient
				body.pickup_active = true
				pass
