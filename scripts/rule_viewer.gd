extends Control

func _ready():
    for tile in $Tiles.get_children():
        tile.connect("indexed_pressed", self, "pressed")

func pressed(index):
    var child = $Tiles.get_child(index)
    $Tiles.visible = false
    $Rule.visible = true
    $Rule/Main.texture = child.texture_normal
