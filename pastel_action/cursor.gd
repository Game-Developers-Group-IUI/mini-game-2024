extends TextureRect

var buttons : Array

@export var button_group : ButtonGroup

@export var current_button : Button
var current_button_index := 0


func _ready() -> void:
	##Gets an array of the buttons you wanna be able to cursor thru
	buttons = button_group.get_buttons()
	if not (buttons.size() <= 0):
		change_button_to_index(0)


func _process(_delta: float) -> void:
	if (not is_instance_valid(current_button)) or (buttons.size() <= 0):
		hide()
		return
	
	##Hide/show based on current button visibility status
	if current_button.is_visible_in_tree():
		show()
	else:
		hide()
	
	if is_visible_in_tree():
		##Move the cursor
		if Input.is_action_just_pressed("move_down"):
			change_button_index(1)
		if Input.is_action_just_pressed("move_up"):
			change_button_index(-1)
		
		##Sizing and positioning
		var current_button_rect := current_button.get_global_rect()
		var height_adjustment:float = (current_button_rect.size.y / 2) - 18
		set_global_position(current_button_rect.position + Vector2(current_button_rect.size.x + 12, height_adjustment))
		set_size(Vector2(12*3, 12*3))
		
		##Press the button
		if Input.is_action_just_pressed("confirm"):
			current_button.emit_signal("button_down")


func change_button_to_index(input: int) -> Button:
	if (buttons.size() <= 0): return
	var out_button: Button = buttons[input]
	current_button = out_button
	return out_button


func change_button_index(add: int) -> void:
	if (buttons.size() <= 0): return
	current_button_index += add
	if current_button_index < 0:
		current_button_index = buttons.size() - 1
	if current_button_index > buttons.size() - 1:
		current_button_index = 0
	
	change_button_to_index(current_button_index)


func _on_visibility_changed() -> void:
	change_button_to_index(0)
