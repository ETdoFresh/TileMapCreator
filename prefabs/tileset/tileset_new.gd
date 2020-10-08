extends GridContainer

var size = Vector2.ZERO
var tiles = []
var nodes = []
var next_id = 1

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
static func init(tileset, size, tiles = [], nodes = []):
    tileset.size = size
    tileset.tiles = tiles
    tileset.nodes = nodes
    tileset.columns = size.x
    return tileset

static func add_tile(tileset, tile):
    var node = TileNode.new()
    TileNode.set_tile(node, tile)
    NodeExt.add_child(tileset, node)
    ArrayExt.append(tileset.tiles, tile)
    ArrayExt.append(tileset.nodes, node)
    return tileset

static func assign_ids(tileset):
    for tile in tileset.tiles:
        tile.id = tileset.next_id
        tileset.next_id += 1
    return tileset
