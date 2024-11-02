extends Sprite2D

## External References
@onready var game: Game = get_node(^"/root/Game")

## Internal References
@onready var book_candy: Sprite2D = %BookCandy
@onready var ingredients_container: Node2D = %IngredientsContainer
@onready var page_text: Label = %PageText

## Variables
var current_page: int = 0


func change_page(index: int) -> void:
	current_page = index
	var recipes: Array[Recipe] = game.level.pentagram.recipes
	page_text.text = recipes[index].text
	if recipes[index].output != Pickup.type.EMPTY:
		book_candy.texture = load("res://assets/candy/" +  Pickup.type.find_key(recipes[index].output) + ".png")
	for i: int in range(ingredients_container.get_child_count()):
		if recipes[index].slots[i] != Pickup.type.EMPTY:
			ingredients_container.get_child(i).texture\
			= load("res://assets/ingredients/" + Pickup.type.find_key(recipes[index].slots[i]) + ".png")
