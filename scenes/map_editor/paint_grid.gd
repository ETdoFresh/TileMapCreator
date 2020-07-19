extends Control

onready var tileset = $Tileset

func _ready():
    for button in $CanvasLayer/VBoxContainer/TopToolbar/HBoxContainer.get_children():
        if button.name != "MenuButton":
            button.connect("pressed", self, "popup_not_yet_implemented")
    
    var _error = $CanvasLayer/GUI_Background.connect("gui_input", $Camera2D, "handle_event")
    
    $CanvasLayer/EmptyTilesetWarning/TilesetButton.connect("pressed", self, "open_tileset_editor")
    $CanvasLayer/VBoxContainer/HBoxContainer/TilesetButton.connect("pressed", self, "open_tileset_editor")

func open_tileset_editor():
    var scene = Scene.TILESET_EDITOR.instance()
    scene.connect("tileset_updated", self, "update_tileset", [scene])
    for tile in tileset.tiles:
        scene.tileset.add_tile(tile)
    add_child(scene)

func update_tileset(scene):
    tileset.clear()
    for tile in scene.tileset.tiles:
        tileset.add_tile(tile.duplicate())
    scene.queue_free()

func popup_not_yet_implemented():
    $CanvasLayer/NotYetImplementedPopup.show()
