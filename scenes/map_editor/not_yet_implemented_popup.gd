extends PopupPanel

func _ready():
    #warning-ignore: return_value_discarded
    $PanelBackground/Panel/Button.connect("pressed", self, "hide")

func _gui_input(event):
    if event.is_pressed():
        hide()
