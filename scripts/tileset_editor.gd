extends Control

signal tileset_updated

const IND_TILE_SCENE = preload("res://scenes/load_single_tile.tscn")
const TILESHEET_SCENE = preload("res://scenes/load_texture.tscn")
const ATLAS_TILESHEET_SCENE = preload("res://scenes/load_texture_atlas_xml.tscn")
const DELETE_OVERLAY_CONTROL = preload("res://scenes/load_single_tile/DeleteOverlayControl.tscn")

var tiles setget , get_tiles

onready var add_tile_button = $CanvasLayer/VBoxContainer/AddIndividualTile
onready var add_tilesheet_button = $CanvasLayer/VBoxContainer/AddTileSheet
onready var add_atlas_tilesheet_button = $CanvasLayer/VBoxContainer/AddAtlasTilesheet
onready var confirm_button = $CanvasLayer/VBoxContainer/Confirm
onready var tileset = $Tileset

func _ready():
    add_tile_button.connect("pressed", self, "add_tile_prompt")
    add_tilesheet_button.connect("pressed", self, "add_tilesheet_prompt")
    add_atlas_tilesheet_button.connect("pressed", self, "add_atlas_tilesheet_prompt")
    confirm_button.connect("pressed", self, "confirm")
    for tile in $DeleteOverlay.get_children():
        var delete_button = tile.get_child(0)
        delete_button.connect("pressed", self, "delete_tile", [tile])

func get_tiles():
    return tileset.tiles

func add_tile_prompt():
    var scene = IND_TILE_SCENE.instance()
    scene.connect("tile_loaded", self, "add_tile", [scene])
    $CanvasLayer.add_child(scene)

func add_tilesheet_prompt():
    var scene = TILESHEET_SCENE.instance()
    scene.connect("tiles_loaded", self, "add_tiles", [scene])
    $CanvasLayer.add_child(scene)

func add_atlas_tilesheet_prompt():
    var scene = ATLAS_TILESHEET_SCENE.instance()
    $CanvasLayer.add_child(scene)

func add_tile(tile_prompt):
    $EmptyMessage.visible = false
    $CanvasLayer/VBoxContainer/Confirm.disabled = false
    $Tileset.add_tile(tile_prompt.tile)
    add_delete_tile()

func add_tiles(tiles_prompt):
    $EmptyMessage.visible = false
    $CanvasLayer/VBoxContainer/Confirm.disabled = false
    for tile in tiles_prompt.tileset.get_children():
        $Tileset.add_tile(tile.duplicate())
        add_delete_tile()

func add_delete_tile():
    var tile = DELETE_OVERLAY_CONTROL.instance()
    var delete_button = tile.get_child(0)
    delete_button.connect("pressed", self, "delete_tile", [tile])
    $DeleteOverlay.add_child(tile)

func delete_tile(tile):
    var i = tile.get_index()
    tile.queue_free()
    $Tileset.remove_tile($Tileset.tiles[i])
    if $Tileset.tiles.size() == 0:
        $EmptyMessage.visible = true
        $CanvasLayer/VBoxContainer/Confirm.disabled = true

func confirm():
    emit_signal("tileset_updated")
