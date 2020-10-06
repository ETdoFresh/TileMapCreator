class_name WaveFunctionCollapse

const SLOT = preload("res://prefabs/slot/slot.gd")

static func map_to_slots(map, tiles):
    var slots = []
    for y in range(map.size.y):
        for x in range(map.size.x):
            var slot
            if map.exists_tile(x, y):
                slot = create_slot(x, y, [map.get_tile(x, y)])
            else:
                slot = create_slot(x, y, tiles)
            slots.append(slot)
            assign_neighbors(slots, slot)
            calculate_entropy(slot, tiles)
    return slots

static func create_slot(x, y, tiles):
    var slot = SLOT.new()
    slot.x = x
    slot.y = y
    slot.tiles = tiles.duplicate()
    return slot

static func assign_neighbors(slots, slot):
    assign_neighbor(slots, slot, "left", "right", -1, 0)
    assign_neighbor(slots, slot, "right", "left", 1, 0)
    assign_neighbor(slots, slot, "top", "bottom", 0, -1)
    assign_neighbor(slots, slot, "bottom", "top", 0, 1)

static func assign_neighbor(slots, slot, neighbor_name, reciprocal_name, offset_x, offset_y):
    var neighbor_x = slot.x + offset_x
    var neighbor_y = slot.y + offset_y
    var neighbor = get_slot(slots, neighbor_x, neighbor_y)
    if neighbor:
        slot[neighbor_name] = neighbor
        assert(neighbor[reciprocal_name] == null)
        neighbor[reciprocal_name] = slot

static func get_slot(slots, x, y):
    for i in range(slots.size()):
        if slots[i].x == x and slots[i].y == y:
            return slots[i]
    return null

static func solve(original_slots, tileset, rules):
    #append_rules(rules, original_slots)
    #collapse_starting_neighbors(original_slots)
    var slots = start_solve(original_slots)
    var slot = select_lowest_entropy(slots)
    while slot != null:
        random_collapse(slot)
        collapse_neighbors(slot, tileset, rules)
        if is_deadend(slots):
            slots = restart_solve(original_slots)
            pass
        slot = select_lowest_entropy(slots)
    return slots_to_map(slots)

static func start_solve(slots):
    var new_slots = slots.duplicate()
    for i in range(slots.size()):
        new_slots[i] = slots[i].duplicate()
    return new_slots
    
static func restart_solve(slots):
    return start_solve(slots)

static func random_collapse(slot):
    var tile = choose_random(slot.tiles)
    slot.tiles = [tile]
    return slot

static func choose_random(array):
    var ri = randi() % array.size()
    return array[ri]

static func collapse_neighbors(slot, tileset, rules):
    var directions = ["top", "bottom", "left", "right"]
    for direction in directions:
        var neighbor = slot[direction]
        if not neighbor: continue
        
        var neighbor_needs_to_collapse_its_neighbors = false
        var neighbor_tiles = neighbor.tiles
        if neighbor_tiles.size() > 1:
            for i in range(neighbor_tiles.size() - 1, -1, -1):
                var neighbor_tile = neighbor_tiles[i]
                var neighbor_index = tileset.get_tile_index(neighbor_tile)
                if not can_be_neighbors(slot, tileset, rules, direction, neighbor_index):
                    remove_tile(neighbor, neighbor_tile)
                    neighbor_needs_to_collapse_its_neighbors = true
        
        if neighbor_needs_to_collapse_its_neighbors:
            calculate_entropy(neighbor, tileset.tiles)
            collapse_neighbors(neighbor, tileset, rules)

static func can_be_neighbors(slot, tileset, rules, direction, neighbor_index):
    for tile in slot.tiles:
        var tile_index = tileset.get_tile_index(tile)
        if rules.can_be_neighbor(tile_index, direction, neighbor_index):
            return true
    return false

static func remove_tile(slot, tile):
    slot.tiles.erase(tile)

static func is_deadend(slots):
    pass

static func select_lowest_entropy(slots):
    if slots.size() <= 1:
        return null
    var lowest_entropy_slot = slots[0]
    for i in range(slots.size()):
        if lowest_entropy_slot.entropy > slots[i].entropy:
            lowest_entropy_slot = slots[i]
    return lowest_entropy_slot

static func slots_to_map(slots):
    pass

static func calculate_entropy(slot, tileset_tiles):
    var tiles = slot.tiles
    if tiles.size() == 0:
        return
        
    var weight = 1.0 / tileset_tiles.size()
    var total_sum_of_weights = weight * tiles.size()
    var log_2_total_sum_of_weights = log(total_sum_of_weights) / log (2)
    var sum_log_2_of_weights = 0
    for _i in range(tiles.size()):
        sum_log_2_of_weights += log(weight) / log(2)
    
    var small_random_value = randf() * 0.001
    
    slot.entropy = log_2_total_sum_of_weights
    slot.entropy -= sum_log_2_of_weights / total_sum_of_weights
    slot.entropy += small_random_value
