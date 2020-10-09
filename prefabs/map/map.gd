class_name Map
extends GridContainer

var size = Vector2.ZERO
var tiles = []

static func add_tile(map, x, y, tile):
    var map_tile = MapTile.new()
    map_tile.x = x
    map_tile.y = y
    MapTile.set_tile(map_tile, tile)
    var original_tile = map.get_child(x + map.size.x * y)
    NodeExt.replace(original_tile, map_tile)
    ArrayExt.append(map.tiles, tile)
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
    
    for i in range(map.get_child_count(), x * y):
        NodeExt.add_child(map, create_empty_control())
    
    for i in range(map.get_child_count(), x * y - 1, -1):
        NodeExt.remove_child(map, map.get_child(i))
    
    return map

static func create_empty_control():
    var control = Control.new()
    control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    control.size_flags_vertical = Control.SIZE_EXPAND_FILL
    return control
