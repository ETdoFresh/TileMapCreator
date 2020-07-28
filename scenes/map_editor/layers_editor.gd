extends Control

onready var layers = $VBoxContainer/ScrollContainer/Layers
onready var move_layer_up = $VBoxContainer/GridContainer/MoveLayerUp
onready var move_layer_down = $VBoxContainer/GridContainer/MoveLayerDown
onready var add_layer = $VBoxContainer/GridContainer/AddLayer
onready var delete_layer = $VBoxContainer/GridContainer/DeleteLayer
onready var rename_layer = $VBoxContainer/GridContainer/RenameLayer

func _ready():
    layers.connect("selection_changed", self, "update_buttons")
    add_layer.connect("pressed", layers, "add_layer")
    delete_layer.connect("pressed", layers, "delete_layer")
    move_layer_up.connect("pressed", layers, "move_selected_up")
    move_layer_down.connect("pressed", layers, "move_selected_down")
    update_buttons()

func update_buttons():
    if layers.selected == null:
        move_layer_down.disable()
        move_layer_up.disable()
        delete_layer.disable()
        rename_layer.disable()
    else:
        delete_layer.enable()
        rename_layer.enable()
        if layers.is_first_layer(layers.selected):
            move_layer_up.disable()
        else:
            move_layer_up.enable()
        
        if layers.is_last_layer(layers.selected):
            move_layer_down.disable()
        else:
            move_layer_down.enable()
