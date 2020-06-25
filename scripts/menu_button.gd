#warning-ignore-all:return_value_discarded

extends Button

func _ready():
    connect("pressed", self, "load_menu")

func load_menu():
    get_tree().change_scene("res://scenes/main.tscn")
