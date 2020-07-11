#warning-ignore-all:return_value_discarded

extends Control

func _ready():
    $VBoxContainer/Button.connect("pressed", self, "load_paint_grid")
    $VBoxContainer/Button2.connect("pressed", self, "load_wfc")
    $VBoxContainer/Button3.connect("pressed", self, "load_simplex")
    $VBoxContainer/Button4.connect("pressed", self, "load_random")
    $VBoxContainer/Button5.connect("pressed", self, "load_load_texture")
    $VBoxContainer/Button6.connect("pressed", self, "load_xml_atlas")

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
