#warning-ignore-all: return_value_discarded

class_name TextureRectAsButton
extends TextureRect

signal pressed(button)

export var disabled = false
export var color_normal = Color(1.0, 1.0, 1.0)
export var color_hover = Color(0.5, 0.5, 0.5)
export var color_focused = Color(0.5, 0.5, 0.5)
export var color_pressed = Color(0.5, 0.5, 0.5)
export var color_disabled = Color(0.5, 0.5, 0.5)

var pressing = false

func _ready():
    if disabled:
        disable()
    else:
        enable()
    
func disable():
    disconnect("focus_entered", self, "set_focused")
    disconnect("focus_exited", self, "set_normal")
    disconnect("mouse_entered", self, "set_hover")
    disconnect("mouse_exited", self, "set_normal")
    
func enable():
    connect("visibility_changed", self, "set_normal")
    connect("focus_entered", self, "set_focused")
    connect("focus_exited", self, "set_normal")
    connect("mouse_entered", self, "set_hover")
    connect("mouse_exited", self, "set_normal")

func _gui_input(event):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                emit_signal("pressed", self)

func set_normal():
    self_modulate = color_normal
    
func set_focused():
    self_modulate = color_focused

func set_hover():
    self_modulate = color_focused

func set_pressed():
    self_modulate = color_focused

func set_disabled():
    self_modulate = color_focused
