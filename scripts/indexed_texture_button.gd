#warning-ignore-all:return_value_discarded

extends TextureButton

signal indexed_pressed(index)
signal indexed_mouse_entered(index)
signal indexed_mouse_exited(index)

func _ready():
    connect("pressed", self, "emit_indexed_pressed")
    connect("mouse_entered", self, "emit_indexed_mouse_entered")
    connect("mouse_exited", self, "emit_indexed_mouse_exited")
    connect("visibility_changed", self, "reset_color")

func reset_color():
    if visible:
        modulate = Color(1.0, 1.0, 1.0)

func emit_indexed_pressed():
    modulate = Color(0.5, 0.5, 0.5)
    emit_signal("indexed_pressed", get_index())

func emit_indexed_mouse_entered():
    modulate = Color(0.75, 0.75, 0.75)
    emit_signal("indexed_mouse_entered", get_index())

func emit_indexed_mouse_exited():
    modulate = Color(1.0, 1.0, 1.0)
    emit_signal("indexed_mouse_exited", get_index())
