extends Control

const TILE = preload("res://prefabs/tile/tile_new.gd")
const TILESET = preload("res://prefabs/tileset/tileset_new.gd")
const LAYER_DATA = preload("res://scenes/map_editor/layer_data.gd")
const EDGE_DETECTION = preload("res://scenes/wave_function_collapse_demo/rules_by_edge_detection.gd")

var user_map
var generated_map

onready var tileset = $Tileset
onready var rules = $Rules

func _ready():
    set_tileset(tileset)
    set_rules(tileset, rules)
    #set_user_map(tileset, map)
    #run_wfc(tileset, rules, map)

# warning-ignore:shadowed_variable
static func set_tileset(tileset):
    var tileset_resource = ResourceLoader.load("res://resources/tileset.tres")
    if tileset_resource:
        var tiles = tileset_resource.tiles
        var grid_cells = int(max(round(sqrt(tiles.size())), 1))
        TILESET.init(tileset, Vector2(grid_cells, grid_cells))
        for tile_resource in tiles:
            var tile = TILE.new()
            TILE.set_texture(tile, tile_resource.texture)
            TILE.set_stretch_mode(tile, tile_resource.stretch_mode)
            TILESET.add_tile(tileset, tile)
        TILESET.assign_ids(tileset)
    return tileset

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
static func set_rules(tileset, rules):
    EdgeDetection.match_edges(rules, tileset)
    var tileset_selector = TileSetSelector.new()
    NodeExt.full_rect_layout(tileset_selector)
    TileSetSelector.from_tileset(tileset_selector, tileset)
    NodeExt.replace(tileset, tileset_selector)
    NodeExt.delete(tileset)
    TileSetSelector.connect_tiles_to_rules(tileset_selector, rules)

static func set_user_map(_tileset, _map):
#    var map = Map.new()
#    Map.set_size(8, 8)
#    Map.add_tile_instance(0, 0, tileset.tiles[42])
#    Map.add_tile_instance(0, 1, tileset.tiles[42])
#    Map.add_tile_instance(1, 0, tileset.tiles[42])
#    Map.add_tile_instance(1, 1, tileset.tiles[42])
#    Map.add_tile_instance(2, 1, tileset.tiles[42])
#    return map
#    user_map = LAYER_DATA.new()
#    user_map.size = Vector2(8, 8)
#    user_map.add_tile(Vector2(0,0), tileset.tiles[42])
#    user_map.add_tile(Vector2(0,1), tileset.tiles[42])
#    user_map.add_tile(Vector2(1,0), tileset.tiles[42])
#    user_map.add_tile(Vector2(1,1), tileset.tiles[42])
#    user_map.add_tile(Vector2(2,1), tileset.tiles[42])
    pass

static func run_wfc():
#    var slots = WaveFunctionCollapse.map_to_slots(user_map, tileset.tiles)
#    generated_map = WaveFunctionCollapse.solve(slots, tileset, rules)
    pass

