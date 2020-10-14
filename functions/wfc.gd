class_name WaveFunctionCollapse

const DIRECTIONS = ["top", "bottom", "left", "right"]
const SLOT = preload("res://prefabs/slot/slot.gd")
const LAYER_DATA = preload("res://scenes/map_editor/layer_data.gd")
const SLOTS = preload("res://prefabs/slot/slots.gd")
const YIELD_TIME = 30

static func slots_from_map(slots, map, tiles):
    slots = SLOTS.clear(slots)
    for y in range(map.size.y):
        for x in range(map.size.x):
            var slot
            var tile = Map.get_tile(map, x, y)
            if tile:
                slot = SLOT.init(SLOT.new(), x, y, [tile.tile])
            else:
                slot = SLOT.init(SLOT.new(), x, y, tiles)
            slots = SLOTS.add_slot(slots, slot)
            slot = SLOT.calculate_entropy(slot, tiles)
    return slots

static func map_from_slots(map, slots):
    map = Map.clear(map)
    for slot in slots.slots:
        if slot.tiles.size() > 0:
            Map.add_tile(map, slot.x, slot.y, slot.tiles[0])
    return map

static func solve(original_slots, tileset, rules):
    append_rules(original_slots, tileset, rules)
    collapse_starting_neighbors(original_slots, tileset, rules)
    var slots = start_solve(original_slots)
    var slot = select_lowest_entropy(slots)
    while slot != null:
        random_collapse(slot)
        collapse_neighbors(slot, tileset, rules)
        if is_deadend(slots):
            slots = restart_solve(original_slots)
        slot = select_lowest_entropy(slots)
    return slots

static func solve_coroutine(original_slots, tileset, rules):
    original_slots = append_rules_coroutine(original_slots, tileset, rules)
    while original_slots is GDScriptFunctionState:
        original_slots = original_slots.resume(yield())
    original_slots = collapse_starting_neighbors_coroutine(original_slots, tileset, rules)
    while original_slots is GDScriptFunctionState:
        original_slots = original_slots.resume(yield())
    var slots = start_solve(original_slots)
    var slot = select_lowest_entropy(slots)
    while slot != null:
        slot = random_collapse(slot)
        # TODO: We need to take a look at this func, infinite is_deadend occuring
        slot = collapse_neighbors_coroutine(slot, tileset, rules)
        while slot is GDScriptFunctionState:
            slot = slot.resume(yield())
        if is_deadend(slots):
            slots = restart_solve(original_slots)
        slot = select_lowest_entropy(slots)
    return slots

static func step1(original_slots, tileset, rules):
    var slots = start_solve(original_slots)
    slots = append_rules(slots, tileset, rules)
    slots = collapse_starting_neighbors(slots, tileset, rules)
    return slots

static func step(original_slots, tileset, rules):
    var slots = start_solve(original_slots)
    var slot = select_lowest_entropy(slots)
    if slot != null:
        slot = random_collapse(slot)
        slot = collapse_neighbors(slot, tileset, rules)
        if is_deadend(slots):
            slots = restart_solve(original_slots)
        slot = select_lowest_entropy(slots)
    return slots

static func append_rules(slots_node, tileset, rules):
    var slots = slots_node.slots
    for i in range(slots.size()):
        if slots[i].tiles.size() == 1:
            var tile = slots[i].tiles[0]
            var tile_id = Tileset.get_id(tileset, tile)
            for direction in DIRECTIONS:
                var neighbor = slots[i][direction]
                if neighbor and neighbor.tiles.size() == 1:
                    var neighbor_tile = neighbor.tiles[0]
                    var neighbor_tile_id = Tileset.get_id(tileset, neighbor_tile)
                    if not rules[direction].has([tile_id, neighbor_tile_id]):
                        rules[direction].append([tile_id, neighbor_tile_id])
    return slots_node

static func append_rules_coroutine(slots_node, tileset, rules):
    var start_time = OS.get_ticks_msec()
    var slots = slots_node.slots
    for i in range(slots.size()):
        if slots[i].tiles.size() == 1:
            var current_time = OS.get_ticks_msec()
            if current_time - start_time > YIELD_TIME:
                if not yield():
                    return slots_node
                start_time = OS.get_ticks_msec()
            var tile = slots[i].tiles[0]
            var tile_id = Tileset.get_id(tileset, tile)
            for direction in DIRECTIONS:
                var neighbor = slots[i][direction]
                if neighbor and neighbor.tiles.size() == 1:
                    var neighbor_tile = neighbor.tiles[0]
                    var neighbor_tile_id = Tileset.get_id(tileset, neighbor_tile)
                    if not rules[direction].has([tile_id, neighbor_tile_id]):
                        rules[direction].append([tile_id, neighbor_tile_id])
    return slots_node

static func collapse_starting_neighbors(slots_node, tileset, rules):
    var slots = slots_node.slots
    for i in range(slots.size()):
        if slots[i].tiles.size() == 1:
            collapse_neighbors(slots[i], tileset, rules)
    return slots_node

static func collapse_starting_neighbors_coroutine(slots_node, tileset, rules):
    var slots = slots_node.slots
    for i in range(slots.size()):
        if slots[i].tiles.size() == 1:
            collapse_neighbors_coroutine(slots[i], tileset, rules)
    return slots_node

static func start_solve(slots):
    return SLOTS.copy(slots)

static func restart_solve(slots):
    return start_solve(slots)

static func random_collapse(slot):
    var tile = choose_random(slot.tiles)
    for i in range(slot.tiles.size() - 1, -1, -1):
        var slot_tile = slot.tiles[i]
        if slot_tile != tile:
            SLOT.remove_tile(slot, slot_tile)
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
                var neighbor_id = Tileset.get_id(tileset, neighbor_tile)
                if not can_be_neighbors(slot, tileset, rules, direction, neighbor_id):
                    SLOT.remove_tile(neighbor, neighbor_tile)
                    neighbor_needs_to_collapse_its_neighbors = true
        
        if neighbor_needs_to_collapse_its_neighbors:
            SLOT.calculate_entropy(neighbor, tileset.tiles)
            collapse_neighbors(neighbor, tileset, rules)
    
    return slot

static func collapse_neighbors_coroutine(slot, tileset, rules):
    var start_time = OS.get_ticks_msec()
    var queue = [slot]
    while queue.size() > 0:
        var current_slot = queue.pop_front()
        var directions = ["top", "bottom", "left", "right"]
        for direction in directions:
            var neighbor = current_slot[direction]
            if not neighbor: continue
            
            var current_time = OS.get_ticks_msec()
            if current_time - start_time > YIELD_TIME:
                if not yield():
                    return slot
                start_time = OS.get_ticks_msec()
            
            var neighbor_needs_to_collapse_its_neighbors = false
            var neighbor_tiles = neighbor.tiles
            if neighbor_tiles.size() > 1:
                for i in range(neighbor_tiles.size() - 1, -1, -1):
                    var neighbor_tile = neighbor_tiles[i]
                    var neighbor_id = Tileset.get_id(tileset, neighbor_tile)
                    if not can_be_neighbors(current_slot, tileset, rules, direction, neighbor_id):
                        SLOT.remove_tile(neighbor, neighbor_tile)
                        neighbor_needs_to_collapse_its_neighbors = true
            
            if neighbor_needs_to_collapse_its_neighbors:
                SLOT.calculate_entropy(neighbor, tileset.tiles)
                if current_slot.top: queue.push_back(current_slot.top)
                if current_slot.bottom: queue.push_back(current_slot.bottom)
                if current_slot.left: queue.push_back(current_slot.left)
                if current_slot.right: queue.push_back(current_slot.right)
    
    return slot

# warning-ignore:unused_argument
static func can_be_neighbors(slot, tileset, rules, direction, neighbor_id):
    for tile in slot.tiles:
        if RulesNew.can_be_neighbor(rules, tile.id, direction, neighbor_id):
            return true
    return false

static func is_deadend(slots_node):
    var slots = slots_node.slots
    for i in range(slots.size()):
        if slots[i].tiles.size() == 0:
            return true
    return false

static func select_lowest_entropy(slots_node):
    var slots = slots_node.slots
    if slots.size() <= 1:
        return null
    var lowest_entropy_slot = null
    for i in range(slots.size()):
        if slots[i].tiles.size() > 1:
            if not lowest_entropy_slot:
                lowest_entropy_slot = slots[i]
            elif lowest_entropy_slot.entropy > slots[i].entropy:
                lowest_entropy_slot = slots[i]
    return lowest_entropy_slot

static func slots_to_map(slots):
    var map = Map.new()
    map = Map.set_map_size(map, 8, 8)
    for slot in slots:
        map = Map.add_tile(map, slot.x, slot.y, slot.tiles[0])
    return map

static func map_to_grid(map, grid_parent):
    grid_parent.columns = map.size.y
    for i in range(map.tiles.size()):
        var tile = map.tiles[i]
        var _x = map.x_positions[i]
        var _y = map.y_positions[i]
        var _grid_size = map.grid_size
        grid_parent.add_child(tile.duplicate())
