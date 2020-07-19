#warning-ignore-all:return_value_discarded

extends Control

export var x_size = 15
export var y_size = 15

func _ready():
    $Reset.connect("pressed", self, "reset")
    generate_map()
    
func generate_map():
    var size = x_size * y_size
    for _i in range(size):
        add_square(randi() % $Layer1Palette.get_child_count())

func add_square(index):
    var square = $Layer1Palette.get_child(index)
    var new_square = square.duplicate()
    $SimplexNoise.add_child(new_square)

func reset():
    get_tree().change_scene("res://scenes/random_noise_demo/random_noise_demo.tscn")
