extends PopupPanel

func _ready():
    $PanelBackground/Panel/Button.connect("pressed", self, "hide")

func _gui_input(event):
    if event.is_pressed():
        hide()
