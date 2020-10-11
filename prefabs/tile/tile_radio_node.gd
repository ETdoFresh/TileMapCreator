class_name TileRadioNode
extends TileNode

signal selected

export var disabled = false
export var color_normal = Color(1.0, 1.0, 1.0)
export var color_hover = Color(0.5, 0.5, 0.5)
export var color_pressed = Color(0.25, 0.25, 0.25)
export var color_disabled = Color(0.25, 0.25, 0.25) 
export var color_selected = Color.yellow

var is_selected = false

func _ready():
    mouse_filter = Control.MOUSE_FILTER_STOP
    if not disabled:
        enable()

func disable():
    disconnect("mouse_entered", self, "set_hover")
    disconnect("mouse_exited", self, "set_normal")

func enable():
    var _1 = connect("visibility_changed", self, "set_normal")
    var _2 = connect("mouse_entered", self, "set_hover")
    var _3 = connect("mouse_exited", self, "set_normal")
    var _4 = connect("gui_input", self, "_gui_input")

func _gui_input(event):
    if event is InputEventMouse:
        if event.is_pressed():
            if not event.is_echo():
                emit_signal("selected")

func set_normal():
    self_modulate = color_selected if is_selected else color_normal

func set_hover():
    self_modulate = color_hover

func set_pressed():
    self_modulate = color_pressed

func set_disabled():
    self_modulate = color_disabled

func set_selected():
    is_selected = true
    self_modulate = color_selected

func set_unselected():
    is_selected = false
    self_modulate = color_normal

static func to_tile_node(tile_radio_node):
    var tile_node = TileNode.set_tile(TileNode.new(), tile_radio_node.tile)
    return tile_node