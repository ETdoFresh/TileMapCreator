class_name ButtonBehavior
extends Node

signal pressed

export var disabled = false
export var color_normal = Color(1.0, 1.0, 1.0)
export var color_hover = Color(0.5, 0.5, 0.5)
export var color_pressed = Color(0.25, 0.25, 0.25)
export var color_disabled = Color(0.25, 0.25, 0.25) 

onready var parent = get_parent()

func _ready():
    parent.mouse_filter = Control.MOUSE_FILTER_STOP
    if not disabled:
        enable()

func disable():
    parent.disconnect("mouse_entered", self, "set_hover")
    parent.disconnect("mouse_exited", self, "set_normal")

func enable():
    parent.connect("visibility_changed", self, "set_normal")
    parent.connect("mouse_entered", self, "set_hover")
    parent.connect("mouse_exited", self, "set_normal")
    parent.connect("gui_input", self, "_gui_input")

func _gui_input(event):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                emit_signal("pressed")
                if parent.has_signal("pressed"):
                    parent.emit_signal("pressed")

func set_normal():
    parent.self_modulate = color_normal

func set_hover():
    parent.self_modulate = color_hover

func set_pressed():
    parent.self_modulate = color_pressed

func set_disabled():
    parent.self_modulate = color_disabled
