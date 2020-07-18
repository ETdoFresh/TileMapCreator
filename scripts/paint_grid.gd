extends Node2D

func _ready():
    for button in $CanvasLayer/VBoxContainer/TopToolbar/HBoxContainer.get_children():
        if button.name != "MenuButton":
            button.connect("pressed", self, "popup_not_yet_implemented")
    
    $CanvasLayer/GUI_Background.connect("gui_input", $Camera2D, "handle_event")

func popup_not_yet_implemented():
    $CanvasLayer/NotYetImplementedPopup.show()
