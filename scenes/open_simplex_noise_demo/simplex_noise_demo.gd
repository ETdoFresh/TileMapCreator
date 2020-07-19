#warning-ignore-all:return_value_discarded

extends Control

export var x_size = 15
export var y_size = 15

var noise = OpenSimplexNoise.new()

func _ready():
    $Noise.texture.noise.seed = randi()
    $Reset.connect("pressed", self, "reset")
    
    #From forum: NoiseTexture gets processed in different thread and not ready right away
    #yield(get_tree(), "idle_frame")
    $WaitForNoise.connect("timeout", self, "generate_map")
    
func generate_map():
    var image = $Noise.texture.get_data()
    image.lock()
    
    var size = x_size * y_size
    for i in range(size):
        var x = i % x_size
        var y = i / x_size
        var o = image.get_pixel(x, y).v
        o = map(o, 0.0, 0.9, 0.0, 1.0)
        add_square(o)
        print(i, ": ", o)
    
    image.unlock()

func map(value, original_min, original_max, new_min, new_max):
    var original_range = original_max - original_min
    var normalized_value = (value - original_min) / original_range
    
    var new_range = new_max - new_min
    var new_value = normalized_value * new_range + new_min
    
    return clamp(new_value, new_min, new_max)

func add_square(o):
    o *= 1000
    var threshold = 1.0 / $Layer1Palette.get_child_count() * 1000
    var index = 0
    for i in range(threshold, 1000 + 5, threshold):
        if o <= i:
            var square = $Layer1Palette.get_child(index)
            var new_square = square.duplicate()
            $SimplexNoise.add_child(new_square)
            print(index)
            return
        index += 1

func reset():
    get_tree().change_scene("res://scenes/open_simplex_noise_demo/simplex_noise_demo.tscn")
