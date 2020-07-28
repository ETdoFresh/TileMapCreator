extends VBoxContainer

signal selection_changed

var selected

func _ready():
    var _1 = $Layer1.connect("pressed", self, "change_layer", [$Layer1])
    if get_child_count() > 0:
        change_layer(get_child(0))

func change_layer(layer):
    if selected != layer:
        selected = layer
        for child in get_children():
            child.unhighlight()
        if selected != null:
            selected.highlight()
        emit_signal("selection_changed")

func add_layer():
    var layer = Prefab.LAYER.instance()
    layer.connect("pressed", self, "change_layer", [layer])
    layer.name = get_next_layer_name()
    add_child(layer)
    if selected != null:
        move_child(layer, selected.get_index())
    change_layer(layer)

func delete_layer():
    var layer = selected
    if get_child_count() <= 1:
        change_layer(null)
    elif is_last_layer(selected):
        change_layer(get_above_layer(selected))
    else:
        change_layer(get_below_layer(selected))
    
    layer.queue_free()

func move_selected_up():
    move_child(selected, get_above_layer(selected).get_index())
    emit_signal("selection_changed")

func move_selected_down():
    move_child(selected, get_below_layer(selected).get_index())
    emit_signal("selection_changed")

func get_next_layer_name():
    var prefix = "Layer"
    for i in range(1, 100):
        var name = prefix + String(i)
        if not exists_child_with_name(name):
            return name
    return "NA"

func exists_child_with_name(name):
    for child in get_children():
        if child.name == name:
            return true
    return false

func is_first_layer(layer):
    return layer == get_child(0)

func is_last_layer(layer):
    return layer == get_child(get_child_count() - 1)

func get_above_layer(layer):
    return get_child(layer.get_index() - 1)

func get_below_layer(layer):
    return get_child(layer.get_index() + 1)
