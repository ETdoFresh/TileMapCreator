class_name Tile
extends TextureRectAsButton

signal enabled_changed(tile, enabled)

var enabled = true setget enabled_set, enabled_get

func enabled_set(value):
    enabled = value
    emit_signal("enabled_changed", self, value)

func enabled_get():
    return enabled
