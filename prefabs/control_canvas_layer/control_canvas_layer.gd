tool

class_name ControlCanvasLayer
extends Control

func _ready():
    var _1 = connect("visibility_changed", self, "change_visibility")

func change_visibility():
    var visibility = get_visibility(self)
    for canvas_layer in get_children():
        if canvas_layer is CanvasLayer:
            for child in canvas_layer.get_children():
                child.visible = visibility

func get_visibility(node):
    if node.get_parent() == null:
        return not "visible" in node or node.visible
    elif "visible" in node and not node.visible:
        return false
    else:
        return get_visibility(node.get_parent())
