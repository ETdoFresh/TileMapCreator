class_name Slot
extends Tileset

var entropy
var neighbors = { "top": null, "right": null, "bottom": null, "left": null }

func _ready():
    if not Engine.editor_hint:
        calculate_entropy()

func _process(_delta):
    for tile in active_tiles:
        if tile.get_parent() != self:
            add_child(tile)
    for tile in inactive_tiles:
        if tile.get_parent() == self:
            remove_child(tile)

func calculate_entropy():
    if active_tiles.size() == 0:
        return
        
    var weight = 1.0 / 16
    var total_sum_of_weights = weight * active_tiles.size()
    var log_2_total_sum_of_weights = log(total_sum_of_weights) / log (2)
    var sum_log_2_of_weights = 0
    for _i in range(active_tiles.size()):
        sum_log_2_of_weights += log(weight) / log(2)
    
    var small_random_value = randf() * 0.001
    
    entropy = log_2_total_sum_of_weights
    entropy -= sum_log_2_of_weights / total_sum_of_weights
    entropy += small_random_value

func collapse():
    if active_tiles.size() > 1:
        var random_index = randi() % active_tiles.size()
        for i in range(active_tiles.size() - 1, -1, -1):
            var active_tile = active_tiles[i]
            active_tile.enabled = i == random_index
        add_constant_override("hseparation", 0)
        add_constant_override("vseparation", 0)
        calculate_entropy()

func collapse_neighbors(rules):
    for direction in neighbors:
        
        if not neighbors[direction]: continue
        
        var neighbor = neighbors[direction]
        var neighbor_needs_to_collapse_its_neighbors = false
        var neighbor_tiles = neighbor.active_tiles
        if neighbor_tiles.size() > 1:
            for i in range(neighbor_tiles.size() - 1, -1, -1):
                var neighbor_tile = neighbor_tiles[i]
                var neighbor_index = neighbor.get_tile_index(neighbor_tile)
                if not can_be_neighbors(rules, direction, neighbor_index):
                    neighbor_tile.enabled = false
                    neighbor_needs_to_collapse_its_neighbors = true
                    if neighbor.active_tiles.size() == 1:
                        neighbor.add_constant_override("hseparation", 0)
                        neighbor.add_constant_override("vseparation", 0)
        
        if neighbor_needs_to_collapse_its_neighbors:
            neighbor.calculate_entropy()
            neighbor.collapse_neighbors(rules)

func can_be_neighbors(rules, direction, neighbor_index):
    for tile in active_tiles:
        var tile_index = get_tile_index(tile)
        if rules.can_be_neighbor(tile_index, direction, neighbor_index):
            return true
    return false
