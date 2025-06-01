class_name Tile extends Node2D

var _value: int
@export var current_slot: Slot = null

@export var value_colors: Dictionary[int, Color]

#func _init(value):
	#set_value(value)
	
func set_value(value: int):
	_value = value
	$ColorRect/Label.text = str(value)
	
	var new_color = value_colors[value]
	$ColorRect.color = new_color
	
func get_value() -> int:
	return _value

func move_to_slot(slot: Slot):
	if current_slot:
		current_slot.current_tile = null
		
	if not slot:
		return
	
	global_position = slot.global_position
	current_slot = slot
	slot.current_tile = self
	
func can_merge_with(tile: Tile):
	return tile.get_value() == _value
	
func merge_with(tile: Tile):
	move_to_slot(null)
	queue_free()
	
	var value = tile.get_value()
	tile.set_value(value * 2)
