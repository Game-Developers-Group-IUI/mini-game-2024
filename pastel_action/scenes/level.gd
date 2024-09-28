class_name Level
extends Node2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var ladder_cooldown_timer: Timer = %LadderCooldown

## Static References
@export_category("Basement")
@export var basement_floor: Sprite2D
@export var pentagram: Sprite2D

@export_category("Aboveground")
@export var aboveground_floor: Sprite2D

@export_category("Universal")
@export var walls: StaticBody2D
@export var ladder: Area2D

## Variables
var in_basement: bool = true
var on_ladder_cooldown: bool = false


func _process(_delta: float) -> void:
	## Ladder climbing
	if Input.is_action_just_pressed(&"confirm"):
		for body: PhysicsBody2D in ladder.get_overlapping_bodies():
			if body is Player and not on_ladder_cooldown:
				on_ladder_cooldown = true
				ladder_cooldown_timer.start()
				if in_basement:
					to_aboveground()
				elif not in_basement:
					to_basement()
	##Book pop up
		for body: PhysicsBody2D in $BookWorld.get_overlapping_bodies():
			if body is Player:
				$BookMenu.visible = true
				$BookWorld/SampleBook.visible = false
				game.player.visible = false
	##Book pop down
	if Input.is_action_just_pressed(&"move_down"):
		$BookMenu.visible = false
		$BookWorld/SampleBook.visible = true
		game.player.visible = true

func to_basement() -> void:
	#TODO: switching active states of interactibles that don't exist yet
	in_basement = true
	aboveground_floor.hide()
	basement_floor.show()


func to_aboveground() -> void:
	in_basement = false
	#TODO: switching active states of interactibles that don't exist yet
	aboveground_floor.show()
	basement_floor.hide()


func _on_ladder_cooldown_timeout() -> void:
	on_ladder_cooldown = false
