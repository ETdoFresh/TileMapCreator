class_name TilesetSelector
extends Tileset

var selection

static func from_tileset(tileset_selector, tileset):
    tileset_selector = init(tileset_selector, tileset.size, tileset.tiles)
    tileset_selector.next_id = tileset.next_id
    tileset_selector.visible = tileset.visible
    for tile in tileset.tiles:
        var tile_button_node = TileButtonNode.new()
        TileButtonNode.set_tile(tile_button_node, tile)
        NodeExt.add_child(tileset_selector, tile_button_node)
        ArrayExt.append(tileset_selector.nodes, tile_button_node)
        if not tileset_selector.selection:
            tileset_selector.selection = tile_button_node
    return tileset_selector
