class_name TilesetButtons
extends Tileset

static func from_tileset(tileset_buttons, tileset):
    tileset_buttons = init(tileset_buttons, tileset.size, tileset.tiles)
    tileset_buttons.next_id = tileset.next_id
    tileset_buttons.visible = tileset.visible
    for tile in tileset.tiles:
        var tile_button_node = TileButtonNode.new()
        TileButtonNode.set_tile(tile_button_node, tile)
        NodeExt.add_child(tileset_buttons, tile_button_node)
        ArrayExt.append(tileset_buttons.nodes, tile_button_node)
    return tileset_buttons

static func connect_tiles_to_rules(tileset_buttons, rules):
    for tile_node in tileset_buttons.nodes:
        var tile = tile_node.tile
        tile_node.connect("pressed", rules, "show_rule", [rules, tileset_buttons, tile])
        tile_node.connect("pressed", tileset_buttons, "hide")
    return tileset_buttons
