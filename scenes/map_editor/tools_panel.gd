extends Panel

signal selection_changed(selection)

var selected setget , get_selected

onready var tileset_button = $VBoxContainer/TilesetButton
onready var radio_group = $VBoxContainer/TextureRectRadioGroup

func _ready():
    radio_group.connect("selection_changed", self, "relay_selection_changed")

func relay_selection_changed(selection):
    emit_signal("selection_changed", selection)

func get_selected():
    return radio_group.selected
