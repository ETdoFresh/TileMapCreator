class_name TextureRectButton
extends TextureRect

signal pressed

export var disabled = false
export var color_normal = Color(1.0, 1.0, 1.0)
export var color_hover = Color(0.5, 0.5, 0.5)
export var color_pressed = Color(0.25, 0.25, 0.25)
export var color_disabled = Color(0.25, 0.25, 0.25)

var mouse_enter_connection = null
var mouse_exit_connection = null
var visibility_connection = null

func _ready():
    if disabled:
        disable()
    else: 
        enable()

func disable():
    disabled = true
    set_disabled()
    
    if is_connected("mouse_entered", self, "set_hover"):
        disconnect("mouse_entered", self, "set_hover")
    if is_connected("mouse_exited", self, "set_normal"):
        disconnect("mouse_exited", self, "set_normal")
    if is_connected("visibility_changed", self, "set_normal"):
        disconnect("visibility_changed", self, "set_normal")

func enable():
    disabled = false
    set_normal()
    
    if not is_connected("mouse_entered", self, "set_hover"):
        var _1 = connect("mouse_entered", self, "set_hover")
    if not is_connected("mouse_exited", self, "set_normal"):
        var _1 = connect("mouse_exited", self, "set_normal")
    if not is_connected("visibility_changed", self, "set_normal"):
        var _1 = connect("visibility_changed", self, "set_normal")

func _gui_input(event):
    if disabled:
        return
        
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
