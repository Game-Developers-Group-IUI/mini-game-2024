class_name Pickup
extends CharacterBody2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var sprite: Sprite2D = %Sprite
@onready var pickup_area: Area2D = %PickupArea
@onready var poof_effect: GPUParticles2D = %PoofEffect

## Variables
var pickup_active: bool = false
var sprite_height: float = 0.0
var sprite_accel: float = 0.0
var landed: bool = false
var stopped: bool = false
var penta_area: PentagramArea = null
var deleting: bool = false

## The type of ingredient or candy this pickup is
var item:type

## Every type of ingredient or candy a pickup could be
enum type {
	## Ingredients
	cackling_caramel, crimson_cane, spooky_milk, plague_syrup,
	## Candy
	black_death_licorice, boiling_blood_chew, chemically_treated_coffee, fright_white_chocolate,
	mycelial_truffle_treats, prickly_peppermint, sour_sickle_pops, strawberry_milk,
	surreal_cider_shot, wriggling_worms_o_chewing,
	## Empty type for putting in recipes
	EMPTY,
}

## The color that goes along with each ingredient or candy
## Dictionary{type:Color}
var pickup_colors:Dictionary = {
	## Ingredients
	type.cackling_caramel:Color("dd7312"), type.crimson_cane:Color("d04a3e"),
	type.spooky_milk:Color("57b3ff"), type.plague_syrup:Color("418657"),
	## Candy
	
}

func setup(item_type:type) -> void:
	pickup_active = true
	item = item_type
	if item_type == type.cackling_caramel or item_type == type.crimson_cane\
	or item_type == type.spooky_milk or item_type == type.plague_syrup:
		sprite.texture = load("res://assets/ingredients/" + type.find_key(item_type) + ".png")
	else:
		sprite.texture = load("res://assets/candy/" + type.find_key(item_type) + ".png")


func _process(_delta: float) -> void:
	## pickup
	if Input.is_action_just_pressed(&"confirm"):
		for body: PhysicsBody2D in pickup_area.get_overlapping_bodies():
			if body is Player and not body.pickup_active and\
			## Can only pick up things that are on the same floor as the player
			((get_parent() == game.level.basement_floor and game.level.in_basement)\
			or (get_parent() == game.level.aboveground_floor and not game.level.in_basement)):
				body.cooldown()
				body.pickup = self
				body.pickup_active = true
				pickup_active = true
				if game.level.in_basement:
					reparent(game.level.basement_floor)
				else:
					reparent(game.level.aboveground_floor)
	
	## Pickup anim
	if pickup_active:
		sprite_height = lerpf(sprite_height, -24*4, 0.333)
	else:
		if sprite_height < 0:
			sprite_height += sprite_accel
			sprite_accel += 0.98
		else:
			sprite_height = 0
			sprite_accel = 0
	sprite.position.y = min(0, sprite_height)
	
	## is it "landed"
	if sprite_height >= 0:
		landed = true
	else:
		landed = false
	
	## Velocity and collision
	if landed:
		## Decay speed and set it to zero
		velocity /= 1.5
		if is_zero_approx(velocity.length_squared()):
			velocity = Vector2.ZERO
		## Collide with self and walls and availble for crafting
		collision_mask = 2 + 4
		collision_layer = 2 + 128
	else:
		## Don't collide with self and collide with walls
		collision_mask = 4
		collision_layer = 0
	
	if velocity.is_equal_approx(Vector2.ZERO):
		stopped = true
	else:
		stopped = false
	
	move_and_slide()


func consume() -> void:
	##Kill the thing fancily
	deleting = true
	%Sprite.hide()
	poof_effect.restart()


func _on_poof_effect_finished() -> void:
	if deleting:
		queue_free()
