#warning-ignore-all:return_value_discarded

extends Control

func _ready():
    $GridContainer/Button.connect("pressed", self, "load_paint_grid")
    $GridContainer/Button2.connect("pressed", self, "load_wfc")
    $GridContainer/Button3.connect("pressed", self, "load_simplex")
    $GridContainer/Button4.connect("pressed", self, "load_random")
    $GridContainer/Button5.connect("pressed", self, "load_load_texture")
    $GridContainer/Button6.connect("pressed", self, "load_xml_atlas")
    $GridContainer/Button7.connect("pressed", self, "load_wfc_2")
    $GridContainer/Button8.connect("pressed", self, "load_file_io")
    $GridContainer/Button9.connect("pressed", self, "load_single_tile")

func load_paint_grid():
    get_tree().change_scene_to(Scene.MAP_EDITOR)

func load_wfc():
    get_tree().change_scene_to(Scene.WAVE_FUNCTION_COLLAPSE_DEMO)

func load_simplex():
    get_tree().change_scene_to(Scene.OPEN_SIMPLEX_NOISE_DEMO)

func load_random():
    get_tree().change_scene_to(Scene.RANDOM_NOISE_DEMO)

func load_load_texture():
    get_tree().change_scene_to(Scene.TILESHEET_PROMPT)

func load_xml_atlas():
    get_tree().change_scene_to(Scene.ATLAS_TILESHEET_PROMPT)

func load_wfc_2():
    get_tree().change_scene_to(Scene.WAVE_FUNCTION_COLLAPSE_DEMO2)

func load_file_io():
    get_tree().change_scene_to(Scene.FILE_IO)

func load_single_tile():
    get_tree().change_scene_to(Scene.TILE_PROMPT)
