class_name Tile
extends TextureRect

#warning-ignore: UNUSED_SIGNAL
#warning-ignore: UNUSED_SIGNAL
signal selected
signal pressed

export var url : String = ""

func clear_behavior():
    for child in get_children():
        child.queue_free()

func set_image_behavior():
    clear_behavior()

func set_button_behavior():
    clear_behavior()
    add_child(ButtonBehavior.new())

func set_radio_behavior():
    clear_behavior()
    add_child(RadioBehavior.new())

func set_non_blocking_behavior():
    clear_behavior()
    add_child(NonBlockingBehavior.new())
