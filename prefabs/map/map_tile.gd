class_name MapTile
extends TextureRect

var tile
var x = -1
var y = -1

# warning-ignore:shadowed_variable
static func set_tile(map, tile):
    return TileNode.set_tile(map, tile)
