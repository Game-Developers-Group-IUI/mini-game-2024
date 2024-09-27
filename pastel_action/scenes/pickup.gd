class_name Pickup
extends CharacterBody2D

@onready var sprite: Sprite2D = %Sprite
@onready var pickup_area: Area2D = %PickupArea

var pickup_active: bool = false
var sprite_height: float = 0.0
var sprite_accel: float = 0.0
var landed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## pickup
	if Input.is_action_just_pressed(&"confirm"):
		for body: PhysicsBody2D in pickup_area.get_overlapping_bodies():
			if body is Player and not body.pickup_active:
				body.cooldown()
				body.pickup = self
				body.pickup_active = true
				pickup_active = true
				pass
	
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
