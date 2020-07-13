extends GridContainer

var textures = []

func _ready():            
    for tile in get_children():
        textures.append(tile.texture)
        tile.texture.set_meta("index", tile.get_index())

func _process(_delta):
    if not visible:
        return
    
    columns = int(max(round(sqrt(textures.size())), 1))
    
    while get_child_count() > textures.size():
        remove_child(get_child(0))
        
    for i in range (get_child_count(), textures.size()):        
        var texture_rect = TextureRectAsButton.new()
        texture_rect.expand = true
        texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        texture_rect.anchor_bottom = 1
        texture_rect.anchor_right = 1
        texture_rect.name = "texture_rect_" + String(i)
        add_child(texture_rect)
        
    for i in range(textures.size()):
        var texture_rect = get_child(i)
        texture_rect.texture = textures[i]
        textures[i].set_meta("index", i)
        if textures[i].has_meta("ignore") and textures[i].get_meta("ignore"):
            texture_rect.modulate.a = 0.5
        else:
            texture_rect.modulate.a = 1.0
