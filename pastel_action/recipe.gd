class_name Recipe
extends Resource

@export var output:int
@export var slot_1:int
@export var slot_2:int
@export var slot_3:int
@export var slot_4:int
@export var slot_5:int
@export var slot_6:int
@export var slot_7:int
@export var slot_8:int
@export var slot_9:int
@export var slot_10:int
@export var slot_11:int

var slots:Array[int]

func setup() -> void:
	## Fill array
	slots[0] = slot_1
	slots[1] = slot_2
	slots[2] = slot_3
	slots[3] = slot_4
	slots[4] = slot_5
	slots[5] = slot_6
	slots[6] = slot_7
	slots[7] = slot_8
	slots[8] = slot_9
	slots[9] = slot_10
	slots[10] = slot_11
	pass


func shuffle_ingredients() -> void:
	## Shuffle Array
	var slotsRecipeHold := {}
	var slotsCopy := slots.duplicate()
	for slot : int in slotsCopy:
		#if slot in 
		pass
	pass
