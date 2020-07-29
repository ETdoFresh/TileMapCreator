#warning-ignore-all: return_value_discarded

extends Control

signal tiles_loaded
signal cancelled

var texture

onready var ok = $MainPanel/VBoxContainer/Buttons/HBoxContainer/OK
onready var cancel = $MainPanel/VBoxContainer/Buttons/HBoxContainer/Cancel
onready var image_url = $MainPanel/VBoxContainer/ContentPanel/VBoxContainer/ImageURL
onready var texture_atlas_url = $MainPanel/VBoxContainer/ContentPanel/VBoxContainer/TextureAtlasURL
onready var loading_label = $MainPanel/VBoxContainer/ContentPanel/LoadingLabel
onready var http = $HTTPRequest
onready var tileset = $Tileset

func _ready():
    ok.connect("pressed", self, "download_files")
    cancel.connect("pressed", self, "emit_cancelled")
    
    if get_parent() != get_tree().get_root():
        $MenuButton.queue_free()

func emit_cancelled():
    $MainPanel.visible = false
    emit_signal("cancelled")

func download_files():
    image_url.readonly = true
    texture_atlas_url.readonly = true
    ok.disabled = true
    cancel.disabled = true
    loading_label.visible = true
    loading_label.text = "Downloading Image..."
    http.connect("request_completed", self, "process_image")
    http.request(image_url.text)

func process_image(_result, _response_code, _headers, body):   
    loading_label.text = "Processing Image..."
    var image = Image.new()
    var err = image.load_png_from_buffer(body)
    if err != OK:
        print("Could not load image")
    texture = ImageTexture.new()
    texture.create_from_image(image)
    
    http.disconnect("request_completed", self, "process_image")
    http.connect("request_completed", self, "process_xml")
    var xml_url = texture_atlas_url.text
    http.request(xml_url)
    loading_label.text = "Downloading Texture Atlas..."

func process_xml(_result, _response_code, _headers, body):
    loading_label.text = "Processing Texture Atlas..."
    var xml = parse_xml_texture_atlas(body)
    for subTexture in xml.TextureAtlas[0].SubTexture:
        var atlas_texture = AtlasTexture.new()
        atlas_texture.atlas = texture
        var x = subTexture.x
        var y = subTexture.y
        var width = subTexture.width
        var height = subTexture.height
        atlas_texture.region = Rect2(x, y, width, height)
        var tile = Prefab.TILE.instance()
        tile.texture = atlas_texture
        tile.url = image_url.text
        tileset.add_tile(tile)
    
    $MainPanel.visible = false
    emit_signal("tiles_loaded")
    
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
