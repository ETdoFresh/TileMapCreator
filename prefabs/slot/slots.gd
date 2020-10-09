extends GridContainer

const SLOT = preload("res://prefabs/slot/slot.gd")

var slots = []

# warning-ignore:shadowed_variable
static func copy(slots):
    var copy = slots.get_script().new()
    for slot in slots.slots:
        var slot_copy = SLOT.copy(slot)
        copy = add_slot(copy, slot_copy)
    copy = GridContainerExt.square_off(copy)
    return copy

# warning-ignore:shadowed_variable
static func add_slot(slots, slot):
    slots.slots.append(slot)
    slots = assign_neighbors(slots, slot)
    slots = NodeExt.add_child(slots, slot)
    slots = GridContainerExt.square_off(slots)
    return slots

# warning-ignore:shadowed_variable
static func remove_slot(slots, slot):
    slots.slots.erase(slot)
    #handle_neighbors
    NodeExt.remove_child(slots, slot)
    #slots = GridContainerExt.square_off(slots)
    return slots

# warning-ignore:shadowed_variable
static func clear(slots):
    for i in range(slots.slots.size() - 1, -1, -1):
        remove_slot(slots, slots.slots[i])
    return slots

# warning-ignore:shadowed_variable
static func assign_neighbors(slots, slot):
    assign_neighbor(slots, slot, "left", "right", -1, 0)
    assign_neighbor(slots, slot, "right", "left", 1, 0)
    assign_neighbor(slots, slot, "top", "bottom", 0, -1)
    assign_neighbor(slots, slot, "bottom", "top", 0, 1)
    return slots

# warning-ignore:shadowed_variable
static func assign_neighbor(slots, slot, neighbor_name, reciprocal_name, offset_x, offset_y):
    var neighbor_x = slot.x + offset_x
    var neighbor_y = slot.y + offset_y
    var neighbor = get_slot(slots, neighbor_x, neighbor_y)
    if neighbor:
        slot[neighbor_name] = neighbor
        assert(neighbor[reciprocal_name] == null)
        neighbor[reciprocal_name] = slot
    return slots

# warning-ignore:shadowed_variable
static func get_slot(slots, x, y):
    slots = slots.slots
    for i in range(slots.size()):
        if slots[i].x == x and slots[i].y == y:
            return slots[i]
    return null
