extends Control

signal tile_loaded
signal cancelled

var tile

onready var rows = $Main/VBoxContainer/ScrollContainer/VBoxContainer
onready var row = $Main/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer
onready var tile_preview = $Main/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/TileTexture
onready var url = $Main/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/URL
onready var download_button = $Main/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/DownloadButton
onready var add_row_button = $Main/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/AddRowButton
onready var delete_row_button = $Main/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/DeleteRowButton
onready var ok_button = $Main/VBoxContainer/ButtonPanel/HBoxContainer/OK
onready var cancel_button = $Main/VBoxContainer/ButtonPanel/HBoxContainer/Cancel

func _ready():
    download_button.connect("pressed", self, "download_tile")
    add_row_button.connect("pressed", self, "add_row")
    ok_button.connect("pressed", self, "ok")
    cancel_button.connect("pressed", self, "cancel")
    
    if get_parent() != get_tree().get_root():
        while find_node("MenuButton"):
            find_node("MenuButton").free()

func download_tile():
    #warning-ignore:return_value_discarded
    $HTTPRequest.connect("request_completed", self, "download_complete")
    $HTTPRequest.request(url.text)

func download_complete(_result, _response_code, _headers, body):
    var image = Image.new()
    var image_error = image.load_png_from_buffer(body)
    if image_error != OK:
        image_error = image.load_jpg_from_buffer(body)
    if image_error != OK:
        image_error = image.load_webp_from_buffer(body)
    if image_error != OK:
        print("An error occurred while trying to display the image.")

    var texture = ImageTexture.new()
    texture.create_from_image(image)

    tile_preview.init(Tile.new())
    tile_preview.tile.texture = texture
    url.editable = false
    download_button.visible = false
    ok_button.disabled = false

func ok():
    tile = tile_preview.tile
    $Main.visible = false
    emit_signal("tile_loaded")

func cancel():
    $Main.visible = false
    emit_signal("cancelled")

func add_row():
    rows.add_child(row.duplicate())
    ## TODO: Connect buttons to events
    ## TODO: Have a "pristine" row which is duplicatable
