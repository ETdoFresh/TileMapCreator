class_name TextureRectRadio
extends TextureRect

signal selected

export var normal_color = Color.white
export var hover_color = Color.gray
export var selected_color = Color.yellow

var is_selected = false

onready var parent = get_parent()

func _ready():
    if parent and parent is TextureRectRadioGroup:
        parent.connect("selection_changed", self, "set_selected")
    
    var _1 = connect("mouse_entered", self, "set_hover_color")
    var _2 = connect("mouse_exited", self, "set_normal_color")
    var _3 = connect("visibility_changed", self, "set_normal_color")

func _gui_input(event):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                set_selected(self)
                emit_signal("selected")

func set_selected(selected):
    if selected == self:
        is_selected = true
        set_selected_color()
    else:
        is_selected = false
        set_normal_color()

func set_normal_color():
    if not is_selected:
        modulate = normal_color

func set_hover_color():
    if not is_selected:
        modulate = hover_color

func set_selected_color():
    modulate = selected_color
