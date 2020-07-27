class_name RadioBehavior
extends Node

export var normal_color = Color.white
export var hover_color = Color.gray
export var selected_color = Color.yellow

var is_selected = false

onready var parent = get_parent()
onready var grandparent = parent.get_parent()

func _ready():
    if grandparent and grandparent.has_signal("selection_changed"):
        grandparent.connect("selection_changed", self, "set_selected")
    
    parent.mouse_filter = Control.MOUSE_FILTER_STOP
    parent.connect("mouse_entered", self, "set_hover_color")
    parent.connect("mouse_exited", self, "set_normal_color")
    parent.connect("visibility_changed", self, "set_normal_color")
    parent.connect("gui_input", self, "_gui_input")

func _exit_tree():
    is_selected = false
    set_normal_color()

func _gui_input(event):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                set_selected(parent)
                parent.emit_signal("selected")

func set_selected(selected):
    if selected == parent:
        is_selected = true
        set_selected_color()
    else:
        is_selected = false
        set_normal_color()

func set_normal_color():
    if not is_selected:
        parent.self_modulate = normal_color

func set_hover_color():
    if not is_selected:
        parent.self_modulate = hover_color

func set_selected_color():
    parent.self_modulate = selected_color
