const SLOT = preload("res://prefabs/slot/slot.gd")

var slots = []

func add_slot(x, y, tiles):
    var new_slot = SLOT.new()
    new_slot.x = x
    new_slot.y = y
    new_slot.tiles = tiles.duplicate()
    assign_neighbors(new_slot)
    slots.append(new_slot)
    return new_slot

func assign_neighbors(slot):
    assign_neighbor(slot, "left", "right", -1, 0)
    assign_neighbor(slot, "right", "left", 1, 0)
    assign_neighbor(slot, "above", "below", 0, -1)
    assign_neighbor(slot, "below", "above", 0, 1)

func assign_neighbor(slot, neighbor_name, reciprocal_name, offset_x, offset_y):
    var neighbor_x = slot.x + offset_x
    var neighbor_y = slot.y + offset_y
    var neighbor = get_slot(neighbor_x, neighbor_y)
    if neighbor:
        slot[neighbor_name] = neighbor
        assert(neighbor[reciprocal_name] == null)
        neighbor[reciprocal_name] = slot

func get_slot(x, y):
    for i in range(slots.size()):
        if slots[i].x == x and slots[i].y == y:
            return slots[i]
    return null
