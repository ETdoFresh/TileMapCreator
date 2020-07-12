extends Control

var textures = []

onready var grid = $GridContainer

func _process(_delta):
    if not grid.visible:
        return
    
    grid.columns = max(round(sqrt(textures.size())), 1)
    
    while grid.get_child_count() > textures.size():
        grid.remove_child(grid.get_child(0))
        
    while grid.get_child_count() < textures.size():
        var panel = Panel.new()
        panel.self_modulate = Color.orange
        panel.size_flags_horizontal = Panel.SIZE_EXPAND_FILL
        panel.size_flags_vertical = Panel.SIZE_EXPAND_FILL
        
        var texture_rect = TextureRectAsButton.new()
        texture_rect.expand = true
        texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        texture_rect.anchor_bottom = 1
        texture_rect.anchor_right = 1
        
        grid.add_child(panel)
        panel.add_child(texture_rect)
        
    for i in range(textures.size()):
        var panel = grid.get_child(i)
        var texture_rect = panel.get_child(0)
        texture_rect.texture = textures[i]
        
        if textures[i].has_meta("ignore") and textures[i].get_meta("ignore"):
            panel.modulate.a = 0.5
        else:
            panel.modulate.a = 1.0
