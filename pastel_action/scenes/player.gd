class_name Player
extends CharacterBody2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var cooldown_timer: Timer = %CooldownTimer

## Properties
@export var base_speed: float = 500.0 ## Movement speed, pixels per frame

## Variables
var input_direction: Vector2 = Vector2.ZERO
var on_cooldown: bool = false
var pickup_active: bool = false
var pickup: Pickup = null


func _process(delta: float) -> void:
	## Halt all processing if game is paused
	if game.ui == game.state.paused:
		return
	
	
	## Deal with pickups
	if pickup_active and is_instance_valid(pickup):
		pickup.position = lerp(pickup.position, position, 0.666)
		
		## drop
		if Input.is_action_just_pressed(&"confirm") and not on_cooldown:
			pickup.pickup_active = false
			pickup_active = false
			pickup = null
			cooldown()
		
		## throw
		if Input.is_action_just_pressed(&"cancel") and not on_cooldown:
			pickup.velocity = velocity * 6
			pickup.pickup_active = false
			pickup_active = false
			pickup = null
			cooldown()
	move_and_slide()
	
	## Move smoothly
	input_direction = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	var speed := base_speed
	
	if pickup_active:
		speed *= 0.8
	
	if input_direction:
		velocity = input_direction * speed
	else:
		## Decay speed and set it to zero
		velocity /= 2
		if is_zero_approx(velocity.length_squared()):
			velocity = Vector2.ZERO
	
	## Check for cooldown
	if on_cooldown and cooldown_timer.time_left == 0:
		on_cooldown = false

func cooldown() -> void:
	cooldown_timer.start()
	on_cooldown = true
