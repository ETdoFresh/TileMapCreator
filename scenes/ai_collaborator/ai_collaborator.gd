extends Control

const TILE = preload("res://prefabs/tile/tile_new.gd")
const TILESET = preload("res://prefabs/tileset/tileset_new.gd")
const LAYER_DATA = preload("res://scenes/map_editor/layer_data.gd")
const EDGE_DETECTION = preload("res://scenes/wave_function_collapse_demo/rules_by_edge_detection.gd")

var generated_map

onready var tileset = $Tileset
onready var rules = $Rules
onready var map = $Map

func _ready():
    tileset = set_tileset(tileset)
    rules = set_rules(rules, tileset)
    tileset = display_rule_selector(tileset, rules)
    map = set_user_map(map, tileset)
    #run_wfc(tileset, rules, map)

# warning-ignore:shadowed_variable
static func set_tileset(tileset):
    var tileset_resource = ResourceLoader.load("res://resources/tileset.tres")
    if tileset_resource:
        var tiles = tileset_resource.tiles
        var grid_cells = int(max(round(sqrt(tiles.size())), 1))
        tileset = TILESET.init(tileset, Vector2(grid_cells, grid_cells))
        for tile_resource in tiles:
            var tile = TILE.new()
            tile = TILE.set_texture(tile, tile_resource.texture)
            tile = TILE.set_stretch_mode(tile, tile_resource.stretch_mode)
            tileset = TILESET.add_tile(tileset, tile)
        tileset = TILESET.assign_ids(tileset)
    return tileset

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
static func set_rules(rules, tileset):
    rules = EdgeDetection.match_edges(rules, tileset)
    return rules

static func display_rule_selector(tileset, rules):
    var tileset_selector = TileSetSelector.new()
    tileset_selector = NodeExt.full_rect_layout(tileset_selector)
    tileset_selector = TileSetSelector.from_tileset(tileset_selector, tileset)
    tileset_selector = NodeExt.replace(tileset, tileset_selector)
    NodeExt.delete(tileset)
    tileset_selector = TileSetSelector.connect_tiles_to_rules(tileset_selector, rules)
    return tileset_selector

static func set_user_map(map, tileset):
    map = Map.set_map_size(map, 8, 8)
    map = Map.add_tile(map, 0, 0, tileset.tiles[42])
    map = Map.add_tile(map, 0, 1, tileset.tiles[42])
    map = Map.add_tile(map, 1, 0, tileset.tiles[42])
    map = Map.add_tile(map, 1, 1, tileset.tiles[42])
    map = Map.add_tile(map, 2, 1, tileset.tiles[42])
    return map

static func run_wfc():
#    var slots = WaveFunctionCollapse.map_to_slots(user_map, tileset.tiles)
#    generated_map = WaveFunctionCollapse.solve(slots, tileset, rules)
    pass

