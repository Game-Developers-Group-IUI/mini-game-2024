class_name Level
extends Node2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var ladder_cooldown_timer: Timer = %LadderCooldown
@onready var book_cooldown_timer: Timer = %BookCooldown

## Static References
@export_category("Basement")
@export var basement_floor: Sprite2D
@export var pentagram: Node2D
@export var book_table: Area2D

@export_category("Aboveground")
@export var aboveground_floor: Sprite2D
@export var bowl: Bowl

@export_category("Universal")
@export var walls: StaticBody2D
@export var ladder: Area2D
@export var book_menu: Sprite2D

## Variables
var in_basement: bool = true
var on_ladder_cooldown: bool = false
var on_book_cooldown: bool = false


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
	## Book pop up
	if Input.is_action_just_pressed(&"confirm") and book_menu.visible == false:
		for body: PhysicsBody2D in book_table.get_overlapping_bodies():
			if body is Player and not on_book_cooldown:
				book_menu.change_page(book_menu.current_page)
				book_menu.visible = true
				Global.open_book.emit()
				on_book_cooldown = true
				book_cooldown_timer.start()
	## Book pop down
	if Input.is_action_just_pressed(&"confirm") and book_menu.visible == true:
		if not on_book_cooldown:
			book_menu.visible = false
			Global.close_book.emit()
			on_book_cooldown = true
			book_cooldown_timer.start()

func to_basement() -> void:
	in_basement = true
	if game.player.pickup:
		game.player.pickup.reparent(basement_floor)
	aboveground_floor.hide()
	basement_floor.show()


func to_aboveground() -> void:
	in_basement = false
	if game.player.pickup:
		game.player.pickup.reparent(aboveground_floor)
	aboveground_floor.show()
	basement_floor.hide()


func _on_ladder_cooldown_timeout() -> void:
	on_ladder_cooldown = false


func _on_ladder_body_entered(body:PhysicsBody2D) -> void:
	if body is Player:
		body.within_ladder = true


func _on_ladder_body_exited(body:PhysicsBody2D) -> void:
	if body is Player:
		body.within_ladder = false


func _on_book_cooldown_timeout() -> void:
	on_book_cooldown = false
