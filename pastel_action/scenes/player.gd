class_name Player
extends CharacterBody2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
#@onready var camera: Camera2D = %Camera2D
@onready var sprite: Sprite2D = %Sprite2D
@onready var particles: GPUParticles2D = %GPUParticles2D
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
		velocity /= (delta * 120)
		if is_zero_approx(velocity.length_squared()):
			velocity = Vector2.ZERO
	move_and_slide()
	
	## Action
	if Input.is_action_just_pressed(&"confirm"):
		activate()


func activate() -> void:
	if not on_cooldown:
		particles.restart()
		on_cooldown = true
		Global.activate.emit(1)


func _on_gpu_particles_2d_finished() -> void:
	cooldown_timer.start()


func _on_cooldown_timer_timeout() -> void:
	on_cooldown = false
