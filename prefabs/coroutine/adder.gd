extends Node

var value = 0
var coroutine = Coroutine.new()

func _ready():
    coroutine.start(self, "add")

func add():
    value += 1

func _process(delta):
    if Input.is_action_just_pressed("ui_accept"):
        if coroutine.active: coroutine.stop()
        else: coroutine.start(self, "add")
    if Input.is_action_just_pressed("reset"):
        coroutine.stop()
        value = 0
        coroutine = Coroutine.new()
        coroutine.start(self, "add")
