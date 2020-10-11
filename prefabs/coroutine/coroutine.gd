class_name Coroutine
extends Reference

var active

func start(obj, func_name):
    active = true
    var start_time = OS.get_ticks_msec()
    var func_ref = funcref(obj, func_name)
    while active:
        var current_time = OS.get_ticks_msec()
        if current_time - start_time > 33:
            print("Pausing... current value %s" % obj.value)
            yield(obj.get_tree(), "idle_frame")
            if not active: return
            start_time = OS.get_ticks_msec()
        func_ref.call_func()

func stop():
    active = false
