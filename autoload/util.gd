extends Node

func get_visibile_child_count(node):
    var count = 0
    for child in node.get_children():
        if child.visible:
            count += 1
    return count

func _process(_delta):
    KeyboardShortcuts.restart_on_ctrl_r(get_tree())
    KeyboardShortcuts.scene_menu_on_ctrl_m(get_tree())
