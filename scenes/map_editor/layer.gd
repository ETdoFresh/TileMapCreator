tool

signal pressed

extends Control

export var layer_type = "Paint"
export var normal_color = Color.blue
export var selected_color = Color.yellow

func _ready():
    $HBoxContainer/Label.text = "%s (%s)" % [name, layer_type]
    var _1 = $HBoxContainer/Label/ButtonBehavior.connect("pressed", self, "emit_pressed_signal")

func emit_pressed_signal():
    emit_signal("pressed")

func highlight():
    self_modulate = selected_color

func unhighlight():
    self_modulate = normal_color
