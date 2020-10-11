class_name AICollaborator
extends Control

func _ready():
    load_tileset_from_file($Tileset)
    load_sample_map($Map, $Tileset)
    generate_slots($Slots, $Tileset, $Rules, $Map)

static func generate_slots(slots, tileset, rules, map):
    rules = set_rules(rules, tileset)
    slots = run_wfc(slots, map, tileset, rules)
    return slots

static func generate_map(map, slots, tileset, rules):
    slots = generate_slots(slots, tileset, rules, map)
    return create_map_from_slots(map, slots)

static func load_tileset_from_file(tileset):
    var tileset_resource = ResourceLoader.load("res://resources/tileset.tres")
    if tileset_resource:
        var tiles = tileset_resource.tiles
        var grid_cells = int(max(round(sqrt(tiles.size())), 1))
        tileset = Tileset.init(tileset, Vector2(grid_cells, grid_cells))
        for tile_resource in tiles:
            var tile = Tile.new()
            tile = Tile.set_texture(tile, tile_resource.texture)
            tile = Tile.set_stretch_mode(tile, tile_resource.stretch_mode)
            tileset = Tileset.add_tile(tileset, tile)
        tileset = Tileset.assign_ids(tileset)
    return tileset

static func set_rules(rules, tileset):
    rules = EdgeDetection.match_edges(rules, tileset)
    return rules

static func display_rule_viewer(tileset, rules):
    var tileset_buttons = TilesetButtons.new()
    tileset_buttons = NodeExt.full_rect_layout(tileset_buttons)
    tileset_buttons = TilesetButtons.from_tileset(tileset_buttons, tileset)
    tileset_buttons = NodeExt.replace(tileset, tileset_buttons)
    NodeExt.delete(tileset)
    tileset_buttons = TilesetButtons.connect_tiles_to_rules(tileset_buttons, rules)
    return tileset_buttons

static func load_sample_map(map, tileset):
    map = Map.set_map_size(map, 8, 8)
    map = Map.add_tile(map, 0, 0, tileset.tiles[42])
    map = Map.add_tile(map, 0, 1, tileset.tiles[42])
    map = Map.add_tile(map, 1, 0, tileset.tiles[42])
    map = Map.add_tile(map, 1, 1, tileset.tiles[42])
    map = Map.add_tile(map, 2, 1, tileset.tiles[42])
    return map

static func create_slots_from_map(slots, map, tileset):
    return WaveFunctionCollapse.slots_from_map(slots, map, tileset.tiles)

static func create_map_from_slots(map, slots):
    return WaveFunctionCollapse.map_from_slots(map, slots)

static func run_wfc(slots, map, tileset, rules):
    slots = WaveFunctionCollapse.slots_from_map(slots, map, tileset.tiles)
    slots = WaveFunctionCollapse.solve(slots, tileset, rules)
    return slots
