extends Control

export var fade_in_duration = 0.5

onready var get_started_button = $Panel/VBoxContainer/Button
onready var fade_in = $FadeIn

func _ready():
    $FadeIn.visible = true
    get_started_button.connect("pressed", self, "load_main_menu")

func _process(delta):
    if fade_in:
        fade_in.modulate.a -= delta / fade_in_duration
        if fade_in.modulate.a <= 0:
            fade_in.queue_free()
            fade_in = null

func load_main_menu():
    var _1 = get_tree().change_scene_to(Scene.MAIN_MENU)
