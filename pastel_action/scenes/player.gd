class_name Player
extends CharacterBody2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var cooldown_timer: Timer = %CooldownTimer
@onready var wand_cooldown: Timer = %WandCooldown
@onready var wand_effect: GPUParticles2D = %WandEffect

## Properties
@export var base_speed: float = 500.0 ## Movement speed, pixels per frame
@export var craft_hold_duration: float = 1.0 ## How long the cancel button must be held to craft

## Variables
var input_direction: Vector2 = Vector2.ZERO
var on_cooldown: bool = false
var pickup_active: bool = false
var pickup: Pickup = null
var within_ladder: bool = false
var wand_held_time: float = 0.0
var wand_waving: bool = false
var on_wand_cooldown: bool = false


func _ready() -> void:
	Global.open_book.connect(game._on_open_book)
	Global.close_book.connect(game._on_close_book)


func _process(delta: float) -> void:
	## Halt all processing if game is paused or viewing book
	if game.ui == game.state.paused:
		return
	
	if game.ui == game.state.running_menu:
		if Input.is_action_just_pressed("move_left"):
			pass
		elif Input.is_action_just_pressed("move_right"):
			pass
		return
	
	## Deal with pickups
	if pickup_active and is_instance_valid(pickup):
		pickup.global_position = lerp(pickup.global_position, global_position, 0.666)
		
		## Drop
		if Input.is_action_just_pressed(&"confirm") and not on_cooldown:
			if not within_ladder:
				var putting_in_bowl: bool = false
				for body: PhysicsBody2D in game.level.bowl.get_overlapping_bodies():
					## Put in bowl
					if body is Player and game.level.in_basement == false:
						if not (pickup.item == Pickup.type.cackling_caramel or pickup.item == Pickup.type.crimson_cane\
						or pickup.item == Pickup.type.spooky_milk or pickup.item == Pickup.type.plague_syrup):
							game.level.bowl.check_ingredients(pickup)
							cooldown()
							putting_in_bowl = true
				## Drop the item
				if not putting_in_bowl:
					if game.level.in_basement:
						pickup.reparent(game.level.basement_floor)
					else:
						pickup.reparent(game.level.aboveground_floor)
				pickup.pickup_active = false
				pickup_active = false
				pickup = null
		
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
			cooldown()
	
	elif Input.is_action_just_pressed(&"cancel"):
		if not pickup_active and not wand_waving and not on_wand_cooldown:
			wand_waving = true
			wand_effect.restart()
	
	elif Input.is_action_just_released(&"cancel"):
		wand_waving = false
		on_wand_cooldown = true
		wand_effect.emitting = false
		wand_cooldown.start()
		if wand_held_time >= craft_hold_duration:
			print("Craft")
			game.level.pentagram.craft()
		wand_held_time = 0
	
	elif Input.is_action_pressed(&"cancel"):
		if wand_waving:
			wand_held_time += delta
	
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


func _on_wand_cooldown_timeout() -> void:
	on_wand_cooldown = false


func _on_wand_effect_finished() -> void:
	pass
	if wand_waving:
		wand_effect.restart()
