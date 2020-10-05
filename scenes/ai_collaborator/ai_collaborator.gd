extends Control

const LAYER_DATA = preload("res://scenes/map_editor/layer_data.gd")
const EDGE_DETECTION = preload("res://scenes/wave_function_collapse_demo/rules_by_edge_detection.gd")

var tileset: Tileset = Tileset.new()
var rules: Rules = Rules.new()
var user_map
var generated_map

func _ready():
    set_tileset(null)
    set_rules(null)
    set_user_map(null)

func _process(_delta):
    pass

func set_tileset(_set_tileset):
    var tileset_resource = ResourceLoader.load("res://resources/tileset.tres")
    if tileset_resource:
        for tile_resource in tileset_resource.tiles:
            var tile = Prefab.TILE.instance()
            tile.texture = tile_resource.texture
            tile.stretch_mode = tile_resource.stretch_mode
            tileset.add_tile(tile)
            tile.set_radio_behavior()
    #tileset = set_tileset

func set_rules(_set_rules):
    var edge_detection = EDGE_DETECTION.new()
    rules.rules = edge_detection.match_edges(tileset)

func set_user_map(_set_user_map):
    user_map = LAYER_DATA.new()
    user_map.add_tile(Vector2(0,0), tileset.tiles[42])
    user_map.add_tile(Vector2(0,1), tileset.tiles[42])
    user_map.add_tile(Vector2(1,0), tileset.tiles[42])
    user_map.add_tile(Vector2(1,1), tileset.tiles[42])

func run_wfc():
    pass

func display_generated_map():
    pass
