class_name NonBlockingBehavior
extends Node

onready var parent = get_parent()

func _ready():
    parent.mouse_filter = Control.MOUSE_FILTER_IGNORE
