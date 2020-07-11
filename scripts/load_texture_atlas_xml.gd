extends Control

func _ready():
    var path = "res://sprites/kenney_medievalrtspack/Spritesheet/medievalRTS_spritesheet.xml"
    var xml = parse_xml_texture_atlas(path)
    var image_file = xml.TextureAtlas[0].imagePath
    var image_path = path.replace("medievalRTS_spritesheet.xml", image_file)
    
    var image = Image.new()
    var err = image.load(image_path)
    if err != OK:
        print("Could not load image")
    var texture = ImageTexture.new()
    texture.create_from_image(image)
    
    var ta = AtlasTexture.new()
    ta.atlas = texture
    ta.region = Rect2(0,0,64,64)
    
    for subTexture in xml.TextureAtlas[0].SubTexture:
        var atlas_texture = AtlasTexture.new()
        atlas_texture.atlas = texture
        var x = subTexture.x
        var y = subTexture.y
        var width = subTexture.width
        var height = subTexture.height
        atlas_texture.region = Rect2(x, y, width, height)
        var texture_rect = TextureRect.new()
        texture_rect.texture = atlas_texture
        texture_rect.name = subTexture.name
        texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
        $GridContainer.add_child(texture_rect)
    
func parse_xml_texture_atlas(path):
    var texture_atlas = {}
    var xml = XMLParser.new()
    xml.open(path)
    
    var current_node = texture_atlas
    while xml.read() == OK:
        
        var node_type = xml.get_node_type()
        
        if not [1,2].has(node_type):
            continue
        
        var node_name = xml.get_node_name()
        
        if not current_node.has(node_name):
            current_node[node_name] = []
        
        var new_node = {}
        
        for i in xml.get_attribute_count():
            var attribute_name = xml.get_attribute_name(i)
            var attribute_value = xml.get_attribute_value(i)
            new_node[attribute_name] = attribute_value
        
        current_node[node_name].append(new_node)
        
        if node_type == 1 and node_name.to_lower() == "textureatlas":
            current_node = new_node
    
    return texture_atlas
