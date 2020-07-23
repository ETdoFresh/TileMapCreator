class_name Tile
extends Resource

signal texture_changed

export var url : String = ""
export var region : Rect2 = Rect2()
export var texture : Texture = null setget emit_signal_texture_changed

func emit_signal_texture_changed(value):
    texture = value
    emit_signal("texture_changed")
