extends Node

onready var camera = get_parent().get_parent().get_node("Camera2D")
onready var grid = get_parent().get_parent().get_node("GridBackground")
onready var layer_viewer = get_parent().get_parent().get_node("LayerViewer")
onready var tileset = get_parent().get_parent().get_node("Tileset")
onready var my_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer/Map")
onready var ccc_map = get_parent().get_parent().get_node("UI/CanvasLayer/Control/BottomPanel/HBoxContainer/VBoxContainer2/Map")
onready var map = get_parent().get_parent().get_node("Map")
onready var slots = get_parent().get_parent().get_node("Slots")
onready var rules = get_parent().get_parent().get_node("Rules")

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            ccc_map = Map.copy(ccc_map, my_map)
            ccc_map = AICollaborator.generate_map(ccc_map, slots, tileset, rules)
            map = Map.copy(map, ccc_map)
