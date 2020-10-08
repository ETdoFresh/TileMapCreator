class_name TileNode
extends TextureRect

const TILE = preload("res://prefabs/tile/tile_new.gd")

var tile: TILE

# warning-ignore:shadowed_variable
static func set_tile(tile_node, tile):
    tile_node.tile = tile
    tile_node.texture = tile.texture
    tile_node.stretch_mode = tile.stretch_mode
    tile_node.expand = true
    tile_node.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL
    tile_node.size_flags_vertical = TextureRect.SIZE_EXPAND_FILL
    return tile_node
