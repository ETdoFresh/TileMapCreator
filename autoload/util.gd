extends Node

func get_visibile_child_count(node):
    var count = 0
    for child in node.get_children():
        if child.visible:
            count += 1
    return count
