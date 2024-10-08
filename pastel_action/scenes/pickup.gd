class_name Pickup
extends CharacterBody2D

## External References
@onready var game: Game = get_node(^"/root/Game")

@onready var sprite: Sprite2D = %Sprite
@onready var pickup_area: Area2D = %PickupArea

var pickup_active: bool = false
var sprite_height: float = 0.0
var sprite_accel: float = 0.0
var landed: bool = false

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
			if body is Player and not body.pickup_active:
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
		sprite_height = lerpf(sprite_height, -24, 0.333)
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
		collision_mask = 2 + 4
		collision_layer = 2
	else:
		collision_mask = 4
		collision_layer = 0
	
	#position += velocity
	move_and_slide()
	pass
