class_name TextureRectRadioGroup
extends Control

var selected

signal selection_changed(selection)

func _ready():
    if selected == null and get_child_count() > 0:
        emit_selection_changed(get_child(0))
    
    for child in get_children():
        child.connect("selected", self, "emit_selection_changed", [child])

func emit_selection_changed(value):
    if (selected != value):
        selected = value
        emit_signal("selection_changed", value)
