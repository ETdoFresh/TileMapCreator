class_name AICollaborator
extends Control

const TILE = preload("res://prefabs/tile/tile_new.gd")
const LAYER_DATA = preload("res://scenes/map_editor/layer_data.gd")
const EDGE_DETECTION = preload("res://scenes/wave_function_collapse_demo/rules_by_edge_detection.gd")

func _ready():
    load_tileset_from_file($Tileset)
    load_sample_map($Map, $Tileset)
    generate_slots($Slots, $Tileset, $Rules, $Map)

static func generate_slots(slots, tileset, rules, map):
    rules = set_rules(rules, tileset)
    slots = create_slots_from_map(slots, map, tileset)
    slots = run_wfc(slots, map, tileset, rules)
    return slots

static func load_tileset_from_file(tileset):
    var tileset_resource = ResourceLoader.load("res://resources/tileset.tres")
    if tileset_resource:
        var tiles = tileset_resource.tiles
        var grid_cells = int(max(round(sqrt(tiles.size())), 1))
        tileset = Tileset.init(tileset, Vector2(grid_cells, grid_cells))
        for tile_resource in tiles:
            var tile = TILE.new()
            tile = TILE.set_texture(tile, tile_resource.texture)
            tile = TILE.set_stretch_mode(tile, tile_resource.stretch_mode)
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

static func run_wfc(slots, map, tileset, rules):
    var original_slots = slots
    slots = WaveFunctionCollapse.slots_from_map(slots, map, tileset.tiles)
    slots = WaveFunctionCollapse.solve(slots, tileset, rules)
    slots = NodeExt.replace(original_slots, slots)
    slots = NodeExt.full_rect_layout(slots)
    return slots
