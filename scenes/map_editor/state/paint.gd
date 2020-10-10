extends Node

const TEMP_TEXTURE = preload("res://sprites/et/no_texture/no_texture.svg")

var is_painting = false

onready var screen_size = Vector2(1280,720) # get_viewport().size
onready var camera = get_parent().get_parent().get_node("Camera2D")
onready var grid = get_parent().get_parent().get_node("GridBackground")
onready var layer_viewer = get_parent().get_parent().get_node("LayerViewer")
onready var tileset = get_parent().get_parent().get_node("UI/CanvasLayer/Control/VBoxContainer/ContentUI/LayersPanel/Tileset")
onready var my_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer/Map")
onready var ccc_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer2/Map")

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            is_painting = true
        else:
            is_painting = false
    
    if event is InputEventMouse:
        if is_painting:
            var selected_tile = tileset.selected
            if selected_tile != null:
                var tile_position = get_world_position(event.global_position) / 64
                layer_viewer.selected.add_tile(tile_position, selected_tile.duplicate())
                #Map.add_tile(my_map, tile_position.x, tile_position.y, selected_tile)

func get_world_position(screen_position):
    var screen_center = screen_size / 2
    var from_center = screen_position - screen_center
    from_center.x *= camera.zoom.x
    from_center.y *= camera.zoom.y
    var world_center = camera.get_camera_screen_center()
    return world_center + from_center
