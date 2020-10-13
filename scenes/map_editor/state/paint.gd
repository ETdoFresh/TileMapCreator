extends Node

const TEMP_TEXTURE = preload("res://sprites/et/no_texture/no_texture.svg")

var is_painting = false
var coroutine = null

onready var camera = get_parent().get_parent().get_node("Camera2D")
onready var grid = get_parent().get_parent().get_node("GridBackground")
onready var layer_viewer = get_parent().get_parent().get_node("LayerViewer")
onready var tileset = get_parent().get_parent().get_node("UI/CanvasLayer/Control/VBoxContainer/ContentUI/LayersPanel/Tileset")
onready var map = get_parent().get_parent().get_node("Map")
onready var my_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer/Map")
onready var ccc_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer2/Map")
onready var slots = get_parent().get_parent().get_node("Slots")
onready var rules = get_parent().get_parent().get_node("Rules")

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            is_painting = true
        else:
            is_painting = false
    
    if event is InputEventMouse:
        if is_painting:
            var selected_tile = tileset.selection
            if selected_tile != null:
                var pointer_position = get_world_position(event.global_position) / 64
                layer_viewer.selected.add_tile(pointer_position, selected_tile)
                var x = int(floor(pointer_position.x))
                var y = int(floor(pointer_position.y))
                var map_tile = Map.get_tile(my_map, x, y)
                if map_tile:
                    if map_tile.tile != selected_tile.tile:
                        my_map = Map.remove_tile(my_map, map_tile)
                        my_map = Map.add_tile(my_map, x, y, selected_tile.tile)
                        update_ai_collaborator()
                else:
                    my_map = Map.add_tile(my_map, x, y, selected_tile.tile)
                    update_ai_collaborator()

func update_ai_collaborator():
    if coroutine: 
        coroutine = null
    ccc_map = Map.copy(ccc_map, my_map)
    coroutine = AICollaborator.generate_map(ccc_map, slots, tileset, rules)
    if not coroutine is GDScriptFunctionState:
        map = Map.copy(map, coroutine)
        coroutine = null

func _process(_delta):
    if coroutine:
        coroutine = coroutine.resume(true)
        if not coroutine is GDScriptFunctionState:
            map = Map.copy(map, coroutine)
            coroutine = null

func get_world_position(screen_position):
    var screen_center = Util.project_resolution / 2
    var from_center = screen_position - screen_center
    from_center.x *= camera.zoom.x
    from_center.y *= camera.zoom.y
    var world_center = camera.get_camera_screen_center()
    return world_center + from_center
