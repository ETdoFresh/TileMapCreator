extends Node2D

func _ready():
    for button in $CanvasLayer/TopToolbar/HBoxContainer.get_children():
        if button.name != "MenuButton":
            button.connect("pressed", self, "popup_not_yet_implemented")

func popup_not_yet_implemented():
    $CanvasLayer/NotYetImplementedPopup.show()
