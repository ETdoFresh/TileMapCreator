extends Control

#const DATA_PATH = "user://save_01.tres"
const DATA_PATH = "res://prefabs/save/save_01.tres"

onready var is_persistent = $Panel/VBoxContainer/Control/GridContainer/IsPersistent
onready var test_int = $Panel/VBoxContainer/Control/GridContainer/TestInt
onready var test_float = $Panel/VBoxContainer/Control/GridContainer/TestFloat
onready var test_string = $Panel/VBoxContainer/Control/GridContainer/TestString
onready var test_boolean = $Panel/VBoxContainer/Control/GridContainer/TestBoolean
onready var save_button = $Panel/VBoxContainer/Control/HBoxContainer/SaveButton
onready var load_button = $Panel/VBoxContainer/Control/HBoxContainer/LoadButton

func _ready():
    is_persistent.text = String(OS.is_userfs_persistent())
    save_button.connect("pressed", self, "save_data")
    load_button.connect("pressed", self, "load_data")

func save_data():
    var data = Save.new()
    data.test_int = int(test_int.text)
    data.test_float = float(test_float.text)
    data.test_string = test_string.text
    data.test_boolean = test_boolean.pressed
    var _error = ResourceSaver.save(DATA_PATH, data)

func load_data():
    var data = ResourceLoader.load(DATA_PATH, "", true)
    test_int.text = String(data.test_int)
    test_float.text = String(data.test_float)
    test_string.text = data.test_string
    test_boolean.pressed = data.test_boolean
