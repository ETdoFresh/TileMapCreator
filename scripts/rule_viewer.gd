extends Control

func _ready():
    for tile in $Tiles.get_children():
        tile.connect("indexed_pressed", self, "pressed")

func pressed(index):
    var tile = $Tiles.get_child(index)
    $Tiles.visible = false
    $Rule.visible = true
    $Rule/Main.texture = tile.texture_normal
    var directions = ["Top", "Right", "Bottom", "Left"]
    for direction in directions:
        
        for child in $Rule.get_node(direction).get_children():
            child.visible = true
        
        for i in range($Rule.get_node(direction).get_child_count()):
            if not $Rules.can_be_neighbor(index, direction.to_lower(), i):
                $Rule.get_node(direction).get_child(i).visible = false

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.pressed:
            $Tiles.visible = true
            $Rule.visible = false
