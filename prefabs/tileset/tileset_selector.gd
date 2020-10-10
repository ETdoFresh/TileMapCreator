class_name TileSetSelector
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
    return tileset_selector

static func connect_tiles_to_rules(tileset_selector, rules):
    for tile_node in tileset_selector.nodes:
        var tile = tile_node.tile
        tile_node.connect("pressed", rules, "show_rule", [rules, tileset_selector, tile])
        tile_node.connect("pressed", tileset_selector, "hide")
    return tileset_selector
