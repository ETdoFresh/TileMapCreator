extends Control

onready var layers_ui = get_parent().get_node("UI/CanvasLayer/Control/VBoxContainer/ContentUI/LayersPanel/LayersEditor/VBoxContainer/ScrollContainer/Layers")

var layers = []
var layer_data = []
var selected

func _ready():
    layers_ui.connect("selection_changed", self, "update_layers")
    layers_ui.connect("visibility_toggled", self, "update_layers")
    update_layers()

func update_layers():
    for i in range(layers.size() - 1, -1, -1):
        var layer = layers[i]
        if not is_instance_valid(layer) || layer.is_queued_for_deletion():
            layer_data[i].queue_free()
            layers.remove(i)
            layer_data.remove(i)
    
    for layer in layers_ui.get_children():
        if not layers.has(layer):
            var new_layer_data = Prefab.LAYER_DATA.instance()
            new_layer_data.name = layer.name
            add_child(new_layer_data)
            layers.append(layer)
            layer_data.append(new_layer_data)
    
    for i in range(layers.size()):
        layer_data[i].visible = layers[i].get_node("HBoxContainer/CheckBox").pressed
    
    for i in range(layers.size()):
        var layer = layers[i]
        var reverse_index = layers.size() - 1 - layer.get_index()
        if i != reverse_index:
            swap(layers, i, reverse_index)
            swap(layer_data, i, reverse_index)
            var new_layer_data = layer_data[i]
            move_child(new_layer_data, i)
    
    selected = null
    for i in range(layers.size()):
        if layers_ui.selected == layers[i]:
            selected = layer_data[i]
            break

func swap(list, i, j):
    var temp = list[i]
    list[i] = list[j]
    list[j] = temp
