class_name GridRow extends Node2D

@export var slot_count: int = 5
@export var slot_spacing: int = 116

var slots: Array[Slot]

func _ready() -> void:
	var slot_scene: PackedScene = load("res://components/Slot.tscn")
	for i in range(slot_count):
		var slot: Slot = slot_scene.instantiate()
		slot.position.x = i * slot_spacing
		
		slots.append(slot)
		add_child(slot)
		
		if i > 0:
			var previous_slot: Slot = slots[i-1]
			previous_slot.right = slot
			slot.left = previous_slot
			
func push_right() -> void:
	var next_slot = func (slot: Slot):
		return slot.left
	push_tiles(slots[slots.size()-1], next_slot)
	
func push_left() -> void:
	var next_slot = func (slot: Slot):
		return slot.right
	push_tiles(slots[0], next_slot)
	
func push_tiles(
	current_slot: Slot, get_next_slot: Callable
):
	slide_tiles(current_slot, get_next_slot, null)
	merge_tiles(current_slot, get_next_slot)
		
func slide_tiles(current_slot: Slot, get_next_slot: Callable, empty_slot: Slot):
	if current_slot.current_tile and empty_slot:
		current_slot.current_tile.move_to_slot(empty_slot)
		empty_slot = get_next_slot.call(empty_slot)
		
	if current_slot.current_tile == null and empty_slot == null:
		empty_slot = current_slot
		
	var next_slot = get_next_slot.call(current_slot)
	if next_slot:
		slide_tiles(next_slot, get_next_slot, empty_slot)
		
func merge_tiles(slot: Slot, get_next_slot: Callable):
	if not slot.current_tile:
		return
	
	var next_slot: Slot = get_next_slot.call(slot)
	if not next_slot or not next_slot.current_tile:
		return
	
	var next_tile = next_slot.current_tile
	if next_tile.can_merge_with(slot.current_tile):
		next_tile.merge_with(slot.current_tile)
		shift_tile_group(next_slot, get_next_slot)
		
	merge_tiles(next_slot, get_next_slot)
	
func shift_tile_group(slot: Slot, get_next_slot: Callable):
	var next_slot: Slot = get_next_slot.call(slot)
	if not next_slot or not next_slot.current_tile:
		return
		
	var next_tile: Tile = next_slot.current_tile
	next_tile.move_to_slot(slot)
	
	shift_tile_group(next_slot, get_next_slot)
