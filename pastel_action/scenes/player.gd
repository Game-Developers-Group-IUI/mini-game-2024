class_name Player
extends CharacterBody2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var cooldown_timer: Timer = %CooldownTimer

## Properties
@export var speed: float = 500.0 ## Movement speed, pixels per frame

## Variables
var input_direction: Vector2 = Vector2.ZERO
var on_cooldown: bool = false


func _process(delta: float) -> void:
	## Halt all processing if game is paused
	if game.ui == game.state.paused:
		return
	
	input_direction = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	
	## Move smoothly
	if input_direction:
		velocity = input_direction * speed * delta * 60
	else:
		## Decay speed and set it to zero
		velocity /= (delta * 60 * 2)
		if is_zero_approx(velocity.length_squared()):
			velocity = Vector2.ZERO
	move_and_slide()
