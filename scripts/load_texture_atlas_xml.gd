#warning-ignore-all: return_value_discarded

extends Control

var texture

func _ready():
    $MainPanel/VBoxContainer/Buttons/HBoxContainer/OK.connect("pressed", self, "download_files")

func download_files():
    $MainPanel/VBoxContainer/ContentPanel/VBoxContainer/ImageURL.readonly = true
    $MainPanel/VBoxContainer/ContentPanel/VBoxContainer/TextureAtlasURL.readonly = true
    $MainPanel/VBoxContainer/Buttons/HBoxContainer/OK.disabled = true
    $MainPanel/VBoxContainer/Buttons/HBoxContainer/Cancel.disabled = true
    $MainPanel/VBoxContainer/ContentPanel/LoadingLabel.visible = true
    $MainPanel/VBoxContainer/ContentPanel/LoadingLabel.text = "Downloading Image..."
    $HTTPRequest.connect("request_completed", self, "process_image")
    var image_url = $MainPanel/VBoxContainer/ContentPanel/VBoxContainer/ImageURL.text
    $HTTPRequest.request(image_url)

func process_image(_result, _response_code, _headers, body):   
    $MainPanel/VBoxContainer/ContentPanel/LoadingLabel.text = "Processing Image..."
    var image = Image.new()
    var err = image.load_png_from_buffer(body)
    if err != OK:
        print("Could not load image")
    texture = ImageTexture.new()
    texture.create_from_image(image)
    
    $HTTPRequest.disconnect("request_completed", self, "process_image")
    $HTTPRequest.connect("request_completed", self, "process_xml")
    var xml_url = $MainPanel/VBoxContainer/ContentPanel/VBoxContainer/TextureAtlasURL.text
    $HTTPRequest.request(xml_url)
    $MainPanel/VBoxContainer/ContentPanel/LoadingLabel.text = "Downloading Texture Atlas..."

func process_xml(_result, _response_code, _headers, body):
    $MainPanel/VBoxContainer/ContentPanel/LoadingLabel.text = "Processing Texture Atlas..."
    var xml = parse_xml_texture_atlas(body)
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
    
    $MainPanel.visible = false
    
func parse_xml_texture_atlas(buffer):
    var texture_atlas = {}
    var xml = XMLParser.new()
    xml.open_buffer(buffer)
    
    var current_node = texture_atlas
    while xml.read() == OK:
        
        var node_type = xml.get_node_type()
        
        if not [1,2].has(node_type):
            continue
        
        var node_name = xml.get_node_name()
        
        if not current_node.has(node_name):
            current_node[node_name] = []
        
        var new_node = {}
        
        if xml.get_attribute_count() == 0:
            continue
        
        for i in xml.get_attribute_count():
            var attribute_name = xml.get_attribute_name(i)
            var attribute_value = xml.get_attribute_value(i)
            new_node[attribute_name] = attribute_value
        
        current_node[node_name].append(new_node)
        
        if node_type == 1 and node_name.to_lower() == "textureatlas":
            current_node = new_node
    
    return texture_atlas
