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

func load_paint_grid():
    get_tree().change_scene("res://scenes/paint_grid.tscn")

func load_wfc():
    get_tree().change_scene("res://scenes/wave_function_collapse.tscn")

func load_simplex():
    get_tree().change_scene("res://scenes/simplex_noise_demo.tscn")

func load_random():
    get_tree().change_scene("res://scenes/random_noise_demo.tscn")

func load_load_texture():
    get_tree().change_scene("res://scenes/load_texture.tscn")

func load_xml_atlas():
    get_tree().change_scene("res://scenes/load_texture_atlas_xml.tscn")

func load_wfc_2():
    get_tree().change_scene("res://scenes/wfc_2.tscn")

func load_file_io():
    get_tree().change_scene("res://scenes/file_io.tscn")
