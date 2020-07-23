class_name TextureRectRadioGroup
extends Control

signal selection_changed(selection)

var selected = null setget change_selection

func change_selection(value):
    if selected != value:
        selected = value
        emit_signal("selection_changed", value)
