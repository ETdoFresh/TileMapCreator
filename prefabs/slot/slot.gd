extends GridContainer

var entropy = INF
var x = -1
var y = -1
var tiles = []
var top = null
var bottom = null
var left = null
var right = null

static func copy(slot):
    var copy = slot.get_script().new()
    copy = init(copy, slot.x, slot.y, slot.tiles)
    copy.entropy = slot.entropy
    return copy

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
static func init(slot, x, y, tiles):
    slot.x = x
    slot.y = y
    for tile in tiles:
        slot = add_tile(slot, tile)
    slot = GridContainerExt.set_spacing(slot, 0)
    slot = NodeExt.size_flag_fill_and_expand(slot)
    return slot

static func add_tile(slot, tile):
    var node = TileNode.set_tile(TileNode.new(), tile)
    slot = NodeExt.add_child(slot, node)
    slot.tiles = ArrayExt.append(slot.tiles, tile)
    node = NodeExt.size_flag_fill_and_expand(node)
    slot = GridContainerExt.square_off(slot)
    return slot

static func remove_tile(slot, tile):
    var tile_node = get_tile_node(slot, tile)
    slot.tiles = ArrayExt.erase(slot.tiles, tile)
    slot = GridContainerExt.square_off(slot)
    NodeExt.delete(tile_node)
    return slot

static func get_tile_node(slot, tile):
    for slot_tile in slot.get_children():
        if slot_tile.tile == tile:
            return slot_tile
    return null

static func calculate_entropy(slot, tileset_tiles):
# warning-ignore:shadowed_variable
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
    return slot
