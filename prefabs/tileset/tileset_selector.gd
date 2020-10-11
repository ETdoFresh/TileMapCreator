class_name TilesetSelector
extends Tileset

var selection

static func from_tileset(tileset_selector, tileset):
    tileset_selector = init(tileset_selector, tileset.size, tileset.tiles)
    tileset_selector.next_id = tileset.next_id
    tileset_selector.visible = tileset.visible
    for tile in tileset.tiles:
        var tile_radio_node = TileRadioNode.new()
        TileRadioNode.set_tile(tile_radio_node, tile)
        NodeExt.add_child(tileset_selector, tile_radio_node)
        ArrayExt.append(tileset_selector.nodes, tile_radio_node)
        tile_radio_node.connect("selected", tileset_selector, "select", [tileset_selector, tile_radio_node])
        if not tileset_selector.selection:
            tileset_selector.selection = tile_radio_node
    return tileset_selector

static func select(tileset_selector, tile_radio_node):
    tileset_selector.selection = tile_radio_node
    for node in tileset_selector.nodes:
        node.set_unselected()
    tile_radio_node.set_selected()
