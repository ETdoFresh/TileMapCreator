class_name TextureRectButton
extends TextureRect

signal pressed

export var disabled = false
export var color_normal = Color(1.0, 1.0, 1.0)
export var color_hover = Color(0.5, 0.5, 0.5)
export var color_pressed = Color(0.25, 0.25, 0.25)
export var color_disabled = Color(0.25, 0.25, 0.25)

func _ready():
    if not disabled:
        enable()


func disable():
    disconnect("mouse_entered", self, "set_hover")
    disconnect("mouse_exited", self, "set_normal")


func enable():
    var _1 = connect("visibility_changed", self, "set_normal")
    var _4 = connect("mouse_entered", self, "set_hover")
    var _5 = connect("mouse_exited", self, "set_normal")


func _gui_input(event):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                emit_signal("pressed")


func set_normal():
    self_modulate = color_normal


func set_hover():
    self_modulate = color_hover


func set_pressed():
    self_modulate = color_pressed


func set_disabled():
    self_modulate = color_disabled
