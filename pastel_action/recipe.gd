class_name Recipe
extends Resource

@export var output: Pickup.type = Pickup.type.EMPTY
@export var slot_1: Pickup.type = Pickup.type.EMPTY
@export var slot_2: Pickup.type = Pickup.type.EMPTY
@export var slot_3: Pickup.type = Pickup.type.EMPTY
@export var slot_4: Pickup.type = Pickup.type.EMPTY
@export var slot_5: Pickup.type = Pickup.type.EMPTY
@export var slot_6: Pickup.type = Pickup.type.EMPTY
@export var slot_7: Pickup.type = Pickup.type.EMPTY
@export var slot_8: Pickup.type = Pickup.type.EMPTY
@export var slot_9: Pickup.type = Pickup.type.EMPTY
@export var slot_10: Pickup.type = Pickup.type.EMPTY
@export var slot_11: Pickup.type = Pickup.type.EMPTY

@export_multiline var text: String

var slots:Array

func setup() -> void:
	## Fill array
	slots.resize(11)
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
