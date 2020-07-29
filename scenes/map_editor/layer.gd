tool

signal visibility_toggled
signal pressed

extends Control

export var layer_type = "Paint"
export var normal_color = Color.transparent
export var selected_color = Color.blue

func _ready():
    $HBoxContainer/Label.text = "%s (%s)" % [name, layer_type]
    var _1 = $HBoxContainer/Label/ButtonBehavior.connect("pressed", self, "emit_pressed_signal")
    var _2 = $HBoxContainer/CheckBox.connect("toggled", self, "emit_visibility_toggled_signal")

func emit_pressed_signal():
    emit_signal("pressed")

func emit_visibility_toggled_signal(_value):
    emit_signal("visibility_toggled")

func highlight():
    self_modulate = selected_color

func unhighlight():
    self_modulate = normal_color
