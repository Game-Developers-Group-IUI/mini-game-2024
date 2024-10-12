class_name Recipe
extends Resource

@export var output :int
@export var slot_1 := -1
@export var slot_2 := -1
@export var slot_3 := -1
@export var slot_4 := -1
@export var slot_5 := -1
@export var slot_6 := -1
@export var slot_7 := -1

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


func shuffle_ingredients() -> void:
	## Shuffle Array
	var slots_copy := slots.duplicate()
	var slots_rando := []
	for slot : int in slots_copy:
		if slot != -1:
			slots_rando[slots_rando.size()] = slot
	
	slots_rando.shuffle()
	
	var i := 0
	for slot : int in slots_copy:
		if slot != -1:
			slots_copy[i] = slots_rando.pop_front()
		i += 1
	
	slots = slots_copy
