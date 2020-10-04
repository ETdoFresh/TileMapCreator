extends Control

func _ready():
    var _1 = $VBoxContainer/VBoxContainer/Button.connect("pressed", self, "load_game")
    var _2 = $VBoxContainer/VBoxContainer/Button2.connect("pressed", self, "load_tool")
    var _3 = $VBoxContainer/VBoxContainer/Button3.connect("pressed", self, "load_settings")
    var _4 = $Button.connect("pressed", self, "load_debug")

func load_game():
    return get_tree().change_scene_to(Scene.GAME)

func load_tool():
    return get_tree().change_scene_to(Scene.MAP_EDITOR)

func load_settings():
    return null

func load_debug():
    return get_tree().change_scene_to(Scene.SCENE_MENU)
