extends PopupPanel

onready var x_button = $PanelBackground/Panel/Cancel
onready var start_over_completely_button = $PanelBackground/Panel/MarginContainer/VBoxContainer/StartCompletelyOver
onready var start_over_same_tiles = $PanelBackground/Panel/MarginContainer/VBoxContainer/StartOverSameTiles

func _ready():
    x_button.connect("pressed", self, "hide")
    start_over_completely_button.connect("pressed", self, "restart_completely")
    start_over_same_tiles.connect("pressed", self, "restart_same_tiles")

func _gui_input(event):
    if event.is_pressed():
        hide()

func restart_completely():
    return get_tree().change_scene_to(Scene.MAP_EDITOR)

func restart_same_tiles():
    # TODO: Load Tileset from resource file
    return get_tree().change_scene_to(Scene.MAP_EDITOR)
