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
var within_ladder: bool = false


func _ready() -> void:
	Global.open_book.connect(game._on_open_book)
	Global.close_book.connect(game._on_close_book)


func _process(_delta: float) -> void:
	## Halt all processing if game is paused or viewing book
	if game.ui == game.state.paused or game.ui == game.state.running_menu:
		return
	
	## Deal with pickups
	if pickup_active and is_instance_valid(pickup):
		pickup.global_position = lerp(pickup.global_position, global_position, 0.666)
		
		## Drop
		if Input.is_action_just_pressed(&"confirm") and not on_cooldown:
			if not within_ladder:
				## Drop the item
				if game.level.in_basement:
					pickup.reparent(game.level.basement_floor)
				else:
					pickup.reparent(game.level.aboveground_floor)
				pickup.pickup_active = false
				pickup_active = false
				pickup = null
				game.level.bowl.check_ingredients()
				cooldown()
		
		## throw
		if Input.is_action_just_pressed(&"cancel") and not on_cooldown:
			if game.level.in_basement:
				pickup.reparent(game.level.basement_floor)
			else:
				pickup.reparent(game.level.aboveground_floor)
			pickup.velocity = velocity * 6
			pickup.pickup_active = false
			pickup_active = false
			pickup = null
			game.level.bowl.check_ingredients()
			cooldown()
	
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
	move_and_slide()


func cooldown() -> void:
	cooldown_timer.start()
	on_cooldown = true


func _on_cooldown_timeout() -> void:
	on_cooldown = false
