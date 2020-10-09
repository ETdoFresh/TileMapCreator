extends Node

var project_resolution = Vector2(
    ProjectSettings.get("display/window/size/width"),
    ProjectSettings.get("display/window/size/height"))

func get_visibile_child_count(node):
    var count = 0
    for child in node.get_children():
        if child.visible:
            count += 1
    return count

func _ready():
    OS.window_size = Vector2(1920, 1080)
    OS.window_position = Vector2(2560-1920, 1440-1080) / 2
    OS.window_position.x = 0
    OS.current_screen = 1

func _process(_delta):
    KeyboardShortcuts.restart_current_scene_on_ctrl_r(get_tree())
    KeyboardShortcuts.restart_on_ctrl_alt_r(get_tree())
    KeyboardShortcuts.scene_menu_on_ctrl_m(get_tree())
