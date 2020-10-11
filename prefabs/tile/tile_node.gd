class_name TileNode
extends TextureRect

var tile: Tile

# warning-ignore:shadowed_variable
static func set_tile(tile_node, tile):
    tile_node.tile = tile
    tile_node.texture = tile.texture
    tile_node.stretch_mode = tile.stretch_mode
    tile_node.expand = true
    tile_node = NodeExt.size_flag_fill_and_expand(tile_node)
    tile_node = NodeExt.mouse_filter_ignore(tile_node)
    return tile_node
