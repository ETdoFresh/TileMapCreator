tool
class_name Slot
extends GridContainer

var entropy
var neighbors = { "top": null, "right": null, "bottom": null, "left": null }

var tiles = []

func _ready():
    if not Engine.editor_hint:
        calculate_entropy()

func _process(_delta):
    if not Engine.editor_hint:
        columns = int(max(round(sqrt(get_active_tiles().size())), 1))
    else:
        columns = int(max(round(sqrt(get_child_count())), 1))
    
    for child in get_children():
        if not tiles.has(child):
            tiles.append(child)
            calculate_entropy()
    
    for i in range(tiles.size() - 1, -1, -1):
        if not get_children().has(tiles[i]):
            tiles.remove(i)
    
    for child in get_active_tiles():
        child.visible = true
    for child in get_inactive_tiles():
        child.visible = false

func reset():
    for tile in tiles:
        tile.ignore = false

func calculate_entropy():
    if get_active_tiles().size() == 0:
        return
        
    var weight = 1.0 / 16
    var total_sum_of_weights = weight * get_active_tiles().size()
    var log_2_total_sum_of_weights = log(total_sum_of_weights) / log (2)
    var sum_log_2_of_weights = 0
    for _i in range(get_active_tiles().size()):
        sum_log_2_of_weights += log(weight) / log(2)
    
    var small_random_value = randf() * 0.001
    
    entropy = log_2_total_sum_of_weights
    entropy -= sum_log_2_of_weights / total_sum_of_weights
    entropy += small_random_value

func collapse():
    var active_tiles = get_active_tiles()
    if active_tiles.size() > 1:
        var random_index = randi() % active_tiles.size()
        for i in range(active_tiles.size()):
            active_tiles[i].ignore = i != random_index
        add_constant_override("hseparation", 0)
        add_constant_override("vseparation", 0)
        calculate_entropy()

func collapse_neighbors(rules):
    for direction in neighbors:
        
        if not neighbors[direction]: continue
        
        var neighbor = neighbors[direction]
        var neighbor_needs_to_collapse_its_neighbors = false
        var neighbor_tiles = neighbor.get_active_tiles()
        if neighbor_tiles.size() > 1:
            for i in range(neighbor_tiles.size() - 1, -1, -1):
                var neighbor_tile = neighbor_tiles[i]
                var neighbor_index = neighbor.get_tile_index(neighbor_tile)
                if not can_be_neighbors(rules, direction, neighbor_index):
                    neighbor.disable(neighbor_index)
                    neighbor_needs_to_collapse_its_neighbors = true
                    if neighbor.get_active_tiles().size() == 1:
                        neighbor.add_constant_override("hseparation", 0)
                        neighbor.add_constant_override("vseparation", 0)
        
        if neighbor_needs_to_collapse_its_neighbors:
            neighbor.calculate_entropy()
            neighbor.collapse_neighbors(rules)

func can_be_neighbors(rules, direction, neighbor_index):
    for tile in get_active_tiles():
        var tile_index = get_tile_index(tile)
        if rules.can_be_neighbor(tile_index, direction, neighbor_index):
            return true
    return false

func get_active_tiles():
    var active_tiles = []
    for tile in tiles:
        if not tile.ignore:
            active_tiles.append(tile)
    return active_tiles

func get_inactive_tiles():
    var inactive_tiles = []
    for tile in tiles:
        if tile.ignore:
            inactive_tiles.append(tile)
    return inactive_tiles

func get_tile_index(tile):
    for i in range(tiles.size()):
        if tiles[i] == tile:
            return i
    return -1

func enable(i):
    tiles[i].ignore = false

func disable(i):
    tiles[i].ignore = true
