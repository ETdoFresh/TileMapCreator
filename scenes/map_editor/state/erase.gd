extends Node

const TEMP_TEXTURE = preload("res://sprites/et/grid_square.svg")

var is_painting = false
var has_changed = false
var coroutine = null

onready var screen_size = Vector2(1280,720) # get_viewport().size
onready var camera = get_parent().get_parent().get_node("Camera2D")
onready var grid = get_parent().get_parent().get_node("GridBackground")
onready var layer_viewer = get_parent().get_parent().get_node("LayerViewer")
onready var my_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer/Map")
onready var ccc_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer2/LoadContainer/Map")
onready var slots = get_parent().get_parent().get_node("Slots")
onready var rules = get_parent().get_parent().get_node("Rules")
onready var loading = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer2/LoadContainer/LoadImage")
onready var tileset = get_parent().get_parent().get_node("UI/CanvasLayer/Control/VBoxContainer/ContentUI/LayersPanel/Tileset")
onready var map = get_parent().get_parent().get_node("Map")

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            is_painting = true
        else:
            is_painting = false
            if has_changed:
                has_changed = false
                update_ai_collaborator()
    
    if event is InputEventMouse:
        if is_painting:
            var pointer_position = get_world_position(event.global_position) / 64
            layer_viewer.selected.remove_position(pointer_position)
            
            var x = int(floor(pointer_position.x))
            var y = int(floor(pointer_position.y))
            var map_tile = Map.get_tile(my_map, x, y)
            if map_tile:
                Map.remove_tile(my_map, map_tile)
                has_changed = true

func _process(_delta):
    if coroutine:
        coroutine = coroutine.resume(true)
        if not coroutine is GDScriptFunctionState:
            map = Map.copy(map, coroutine)
            coroutine = null
            loading.visible = false

func update_ai_collaborator():
    if coroutine: 
        coroutine = null
    ccc_map = Map.copy(ccc_map, my_map)
    coroutine = AICollaborator.generate_map_coroutine(ccc_map, slots, tileset, rules)
    loading.visible = true
    if not coroutine is GDScriptFunctionState:
        map = Map.copy(map, coroutine)
        coroutine = null
        loading.visible = false

func get_world_position(screen_position):
    var screen_center = screen_size / 2
    var from_center = screen_position - screen_center
    from_center.x *= camera.zoom.x
    from_center.y *= camera.zoom.y
    var world_center = camera.get_camera_screen_center()
    return world_center + from_center
