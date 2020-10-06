class_name WaveFunctionCollapse

const SLOTS = preload("res://prefabs/slot/slots.gd")

static func map_to_slots(map, tileset):
    var slots = SLOTS.new()
    for y in range(map.size.y):
        for x in range(map.size.x):
            if map.exists_tile(x, y):
                slots.add_slot(x, y, [map.get_tile(x, y)])
            else:
                slots.add_slot(x, y, tileset)
    return slots

static func solve(slots, rules):
    var solve_slots #= start_solve(slots)
    var slot = select_lowest_entropy(solve_slots)
    while slot != null:
        random_collapse(slot)
        collapse_neighbors(solve_slots, rules)
        if is_deadend(slots):
            #solve_slots = restart_solve(slots)
            pass
        slot = select_lowest_entropy(solve_slots)
    var map = slots_to_map(solve_slots)
    return map

static func random_collapse(slot):
    var tile = choose_random(slot.tiles)
    slot.tiles = [tile]
    return slot

static func choose_random(array):
    var ri = randi() % array.size
    return array[ri]

static func collapse_neighbors(slot, rules):
    pass

static func is_deadend(slots):
    pass

static func select_lowest_entropy(slots):
    slots = slots.slots
    if slots.size() == 0:
        return null
    var lowest_entropy_slot = slots[0]
    for i in range(slots.size()):
        if lowest_entropy_slot.entropy > slots[i].entropy:
            lowest_entropy_slot = slots[i]
    return lowest_entropy_slot

static func slots_to_map(slots):
    pass
