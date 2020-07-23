extends Control

signal tileset_updated

onready var canvas_layer = $ControlCanvasLayer/CanvasLayer
onready var add_tile_button = $ControlCanvasLayer/CanvasLayer/Control/VBoxContainer/AddIndividualTile
onready var add_tilesheet_button = $ControlCanvasLayer/CanvasLayer/Control/VBoxContainer/AddTileSheet
onready var add_atlas_tilesheet_button = $ControlCanvasLayer/CanvasLayer/Control/VBoxContainer/AddAtlasTilesheet
onready var confirm_button = $ControlCanvasLayer/CanvasLayer/Control/VBoxContainer/Confirm
onready var empty_message = $ControlCanvasLayer/CanvasLayer/Control/EmptyMessage
onready var delete_overlay = $ControlCanvasLayer/CanvasLayer/Control/DeleteOverlay
onready var tileset = $ControlCanvasLayer/CanvasLayer/Control/Tileset

func _ready():
    add_tile_button.connect("pressed", self, "add_tile_prompt")
    add_tilesheet_button.connect("pressed", self, "add_tilesheet_prompt")
    add_atlas_tilesheet_button.connect("pressed", self, "add_atlas_tilesheet_prompt")
    confirm_button.connect("pressed", self, "confirm")
    for tile in delete_overlay.get_children():
        var delete_button = tile.get_child(0)
        delete_button.connect("pressed", self, "delete_tile", [tile])

func add_starting_tiles(tiles):
    if tiles.size() > 0:
        empty_message.visible = false
        confirm_button.disabled = false
    
    for tile in tiles:
        tileset.add_tile(tile)
        tile.set_image_behavior()
        add_delete_tile()

func get_tiles():
    return tileset.tiles

func add_tile_prompt():
    var scene = Scene.TILE_PROMPT.instance()
    scene.connect("tile_loaded", self, "add_tile", [scene])
    canvas_layer.add_child(scene)

func add_tilesheet_prompt():
    var scene = Scene.TILESHEET_PROMPT.instance()
    scene.connect("tiles_loaded", self, "add_tiles", [scene])
    canvas_layer.add_child(scene)

func add_atlas_tilesheet_prompt():
    var scene = Scene.ATLAS_TILESHEET_PROMPT.instance()
    canvas_layer.add_child(scene)

func add_tile(tile_prompt):
    empty_message.visible = false
    confirm_button.disabled = false
    tileset.add_tile(tile_prompt.tile)
    add_delete_tile()

func add_tiles(tiles_prompt):
    empty_message.visible = false
    confirm_button.disabled = false
    for tile in tiles_prompt.tileset.get_children():
        tileset.add_tile(tile.duplicate())
        add_delete_tile()

func add_delete_tile():
    var tile = Prefab.DELETE_TILE_OVERLAY.instance()
    var delete_button = tile.get_child(0)
    delete_button.connect("pressed", self, "delete_tile", [tile])
    delete_overlay.add_child(tile)

func delete_tile(tile):
    var i = tile.get_index()
    tile.queue_free()
    tileset.remove_tile(tileset.tiles[i])
    if tileset.tiles.size() == 0:
        empty_message.visible = true
        confirm_button.disabled = true

func confirm():
    emit_signal("tileset_updated")
