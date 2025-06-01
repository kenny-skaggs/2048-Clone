extends Node2D

var rows: Array[GridRow]
var _tile_scene: PackedScene = load("res://components/Tile.tscn")

func _ready() -> void:
		
	rows = [
		$Slots/GridRow,
		$Slots/GridRow2,
		$Slots/GridRow3,
		$Slots/GridRow4,
		$Slots/GridRow5
	]

func _input(event: InputEvent) -> void:
	if event.is_action_released("shift_left"):
		for row in rows:
			row.push_left()
	elif event.is_action_released("shift_right"):
		for row in rows:
			row.push_right()

func _on_slide_down_timer_timeout() -> void:
	move_tiles_down()
	
func move_tiles_down():
	var index = rows.size()
	while index > 1:
		index -= 1
		
		var current_row: GridRow = rows[index]
		var row_one_up: GridRow = rows[index-1]
		for slot_index in row_one_up.slot_count:
			var current_slot: Slot = current_row.slots[slot_index]
			var one_up_slot: Slot = row_one_up.slots[slot_index]
			var current_tile: Tile = current_slot.current_tile
			var one_up_tile: Tile = one_up_slot.current_tile
			
			if not current_tile and one_up_tile:
				one_up_slot.current_tile.move_to_slot(current_slot)
			elif current_tile and one_up_tile and one_up_tile.can_merge_with(current_tile):
				one_up_tile.merge_with(current_tile)

func _on_tile_spawn_timer_timeout() -> void:
	var empty_slots: Array[Slot]
	for slot in $Slots/GridRow.slots:
		if not slot.current_tile:
			empty_slots.append(slot)
			
	if not empty_slots.is_empty():
		var tile_one: Tile = _tile_scene.instantiate()
		tile_one.move_to_slot(empty_slots.pick_random())
		tile_one.set_value(1)
		$Tiles.add_child(tile_one)
