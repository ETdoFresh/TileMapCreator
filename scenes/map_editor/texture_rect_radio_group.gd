extends Control

signal selection_changed(selection)

var selected = null setget change_selection

export var normal_color = Color.white
export var hover_color = Color.gray
export var selected_color = Color.yellow

func _ready():
    if selected == null and get_child_count() > 0:
        change_selection(get_child(0))
    
    for child in get_children():
        child.connect("mouse_entered", self, "set_hover_color", [child])
        child.connect("mouse_exited", self, "set_normal_color", [child])
        child.connect("visibility_changed", self, "set_normal_color", [child])
        child.connect("gui_input", self, "handle_child_gui_input", [child])

func handle_child_gui_input(event, child):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                change_selection(child)

func change_selection(value):
    var previously_selected = selected    
    selected = value   
    set_selected_color(selected)
    
    if previously_selected != value:
        emit_signal("selection_changed", value)
    
    if previously_selected != null:
        set_normal_color(previously_selected)

func set_normal_color(node):
    if node != selected:
        node.modulate = normal_color

func set_hover_color(node):
    if node != selected:
        node.modulate = hover_color

func set_selected_color(node):
    node.modulate = selected_color
