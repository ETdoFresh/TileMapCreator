extends Sprite

onready var starting_alpha = modulate.a

func _ready():
    #warning-ignore:return_value_discarded
    $Timer.connect("timeout", self, "queue_free")

func _process(_delta):
    modulate.a = starting_alpha * $Timer.time_left / $Timer.wait_time
