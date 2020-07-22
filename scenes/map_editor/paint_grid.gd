extends Control

onready var tools_panel = $UI/CanvasLayer/Control/VBoxContainer/ContentUI/ToolsPanel
onready var tileset = $UI/CanvasLayer/Control/VBoxContainer/ContentUI/LayersPanel/Tileset
onready var tileset_button1 = $UI/CanvasLayer/Control/EmptyTilesetWarning/TilesetButton
onready var tileset_button2 = tools_panel.tileset_button
onready var top_toolbar = $UI/CanvasLayer/Control/VBoxContainer/TopToolbar/HBoxContainer
onready var not_yet_implemented_popup = $UI/CanvasLayer/Control/NotYetImplementedPopup
onready var empty_tileset_warning = $UI/CanvasLayer/Control/EmptyTilesetWarning

func _ready():
    for button in top_toolbar.get_children():
        if button.name != "MenuButton":
            button.connect("pressed", self, "popup_not_yet_implemented")
    
    tileset_button1.connect("pressed", self, "open_tileset_editor")
    tileset_button2.connect("pressed", self, "open_tileset_editor")
    tools_panel.connect("selection_changed", self, "select_tool")
    
    refresh()
    center_camera_on_grid()
    select_tool(tools_panel.selected)

func select_tool(selection):
    $UI/CanvasLayer/Control/VBoxContainer/ContentUI/VBoxContainer/ToolName.text = selection.name

func center_camera_on_grid():
    $Camera2D.position = $GridBackground.rect_position + $GridBackground.rect_size / 2

func refresh():
    if tileset.tiles.size() > 0:
        empty_tileset_warning.visible = false
    else:
        empty_tileset_warning.visible = true

func open_tileset_editor():
    visible = false
    var tileset_editor = Scene.TILESET_EDITOR.instance()
    add_child(tileset_editor)
    tileset_editor.add_starting_tiles(tileset.tiles)
    tileset_editor.connect("tileset_updated", self, "update_tileset", [tileset_editor])

func update_tileset(tileset_editor):
    tileset.clear()
    for tile in tileset_editor.tileset.tiles:
        tileset.add_tile(tile)
    tileset_editor.queue_free()
    visible = true
    refresh()

func popup_not_yet_implemented():
    not_yet_implemented_popup.show()
