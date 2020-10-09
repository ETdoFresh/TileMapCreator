class_name MapTile
extends TextureRect

var tile
var x = -1
var y = -1

static func set_tile(map, tile):
    return TileNode.set_tile(map, tile)
