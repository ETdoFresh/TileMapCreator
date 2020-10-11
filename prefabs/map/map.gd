class_name Map
extends GridContainer

var size = Vector2.ZERO
var tiles = []

func _ready():
    set_map_size(self, 10, 10)

static func add_tile(map, x, y, tile):
    assert(get_tile(map, x, y) == null)
    var map_tile = MapTile.new()
    map_tile.x = x
    map_tile.y = y
    MapTile.set_tile(map_tile, tile)
    var original_tile = map.get_child(x + map.size.x * y)
    NodeExt.replace(original_tile, map_tile)
    ArrayExt.append(map.tiles, map_tile)
    return map

static func remove_tile(map, tile):
    ArrayExt.erase(map.tiles, tile)
    var empty = create_empty_control()
    NodeExt.replace(tile, empty)
    return map

static func get_tile(map, x, y):
    for map_tile in map.tiles:
        if map_tile.x == x and map_tile.y == y:
            return map_tile
    return null

static func set_map_size(map, x, y):
    map.size.x = x
    map.size.y = y
    map.columns = x
    for _i in range(map.get_child_count(), x * y):
        NodeExt.add_child(map, create_empty_control())
    for i in range(map.get_child_count() - 1, x * y - 1, -1):
        NodeExt.remove_child(map, map.get_child(i))
    return map

static func create_empty_control():
    var control = Control.new()
    control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    control.size_flags_vertical = Control.SIZE_EXPAND_FILL
    return control

static func clear(map):
    map.tiles = ArrayExt.clear(map.tiles)
    map = NodeExt.delete_all_children(map)
    map = set_map_size(map, map.size.x, map.size.y)
    return map

static func copy(destination, source):
    destination = clear(destination)
    for tile in source.tiles:
        destination = add_tile(destination, tile.x, tile.y, tile.tile)
    return destination
