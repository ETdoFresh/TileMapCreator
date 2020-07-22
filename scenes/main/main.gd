extends Control

func _ready():
    var _1 = $GridContainer/Button.connect("pressed", self, "load_paint_grid")
    var _2 = $GridContainer/Button2.connect("pressed", self, "load_wfc")
    var _3 = $GridContainer/Button3.connect("pressed", self, "load_simplex")
    var _4 = $GridContainer/Button4.connect("pressed", self, "load_random")
    var _5 = $GridContainer/Button5.connect("pressed", self, "load_load_texture")
    var _6 = $GridContainer/Button6.connect("pressed", self, "load_xml_atlas")
    var _7 = $GridContainer/Button7.connect("pressed", self, "load_wfc_2")
    var _8 = $GridContainer/Button8.connect("pressed", self, "load_file_io")
    var _9 = $GridContainer/Button9.connect("pressed", self, "load_single_tile")

func load_paint_grid():
    return get_tree().change_scene_to(Scene.MAP_EDITOR)

func load_wfc():
    return get_tree().change_scene_to(Scene.WAVE_FUNCTION_COLLAPSE_DEMO)

func load_simplex():
    return get_tree().change_scene_to(Scene.OPEN_SIMPLEX_NOISE_DEMO)

func load_random():
    return get_tree().change_scene_to(Scene.RANDOM_NOISE_DEMO)

func load_load_texture():
    return get_tree().change_scene_to(Scene.TILESHEET_PROMPT)

func load_xml_atlas():
    return get_tree().change_scene_to(Scene.ATLAS_TILESHEET_PROMPT)

func load_wfc_2():
    return get_tree().change_scene_to(Scene.WAVE_FUNCTION_COLLAPSE_DEMO2)

func load_file_io():
    return get_tree().change_scene_to(Scene.FILE_IO)

func load_single_tile():
    return get_tree().change_scene_to(Scene.TILE_PROMPT)
