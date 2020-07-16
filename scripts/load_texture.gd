#warning-ignore-all: return_value_discarded
extends Control

const TILE_SCENE = preload("res://scenes/tile.tscn")

signal texture_loaded
signal cancelled

var url = null
var texture = null
var columns = -1
var rows = -1
var padding_top = -1
var padding_right = -1
var padding_bottom = -1
var padding_left = -1
var spacing = -1

onready var ok_button = $Main/VBoxContainer/ButtonPanel/HBoxContainer/OK
onready var cancel_button = $Main/VBoxContainer/ButtonPanel/HBoxContainer/Cancel
onready var columns_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Columns
onready var rows_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Rows
onready var padding_top_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/HBoxContainer/Padding
onready var padding_right_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/HBoxContainer/Padding2
onready var padding_bottom_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/HBoxContainer/Padding3
onready var padding_left_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/HBoxContainer/Padding4
onready var spacing_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Spacing
onready var texture_rect = $Main/VBoxContainer/ImagePanel/VBoxContainer/HBoxContainer/TextureRect
onready var tileset = $Main/VBoxContainer/ImagePanel/VBoxContainer/HBoxContainer/Tileset

func _ready():
    reset()
    $Main/VBoxContainer/DownloadPanel/Button.connect("pressed", self, "download_image")
    $HTTPRequest.connect("request_completed", self, "download_complete")
    ok_button.connect("pressed", self, "emit_texture_loaded")
    cancel_button.connect("pressed", self, "emit_cancelled")

    columns_field.connect("focus_entered", self, "show_highlight_columns")
    columns_field.connect("focus_exited", self, "hide_highlight_columns")
    rows_field.connect("focus_entered", self, "show_highlight_rows")
    rows_field.connect("focus_exited", self, "hide_highlight_rows")
    padding_top_field.connect("focus_entered", self, "show_highlight_padding")
    padding_top_field.connect("focus_exited", self, "hide_highlight_padding")
    padding_top_field.connect("text_changed", self, "populate_other_paddings")
    padding_right_field.connect("focus_entered", self, "show_highlight_padding")
    padding_right_field.connect("focus_exited", self, "hide_highlight_padding")
    padding_bottom_field.connect("focus_entered", self, "show_highlight_padding")
    padding_bottom_field.connect("focus_exited", self, "hide_highlight_padding")
    padding_left_field.connect("focus_entered", self, "show_highlight_padding")
    padding_left_field.connect("focus_exited", self, "hide_highlight_padding")
    spacing_field.connect("focus_entered", self, "show_highlight_spacing")
    spacing_field.connect("focus_exited", self, "hide_highlight_spacing")

func _process(_delta):
    if $Main/VBoxContainer/ImagePanel.visible:
        if not texture_rect.texture: return
        if not columns_field.text.is_valid_integer(): return
        if not rows_field.text.is_valid_integer(): return
        if not padding_top_field.text.is_valid_integer(): return
        if not padding_right_field.text.is_valid_integer(): return
        if not padding_bottom_field.text.is_valid_integer(): return
        if not padding_left_field.text.is_valid_integer(): return
        if not spacing_field.text.is_valid_integer(): return
        
        columns = int(columns_field.text)
        rows = int(rows_field.text)
        padding_top = int(padding_top_field.text)
        padding_right = int(padding_right_field.text)
        padding_bottom = int(padding_bottom_field.text)
        padding_left = int(padding_left_field.text)
        spacing = int(spacing_field.text)
        
        if columns <= 0: return
        if rows <= 0: return
        if padding_top < 0: return
        if padding_right < 0: return
        if padding_bottom < 0: return
        if padding_left < 0: return
        if spacing < 0: return
        
        var count = rows * columns
        var size = texture_rect.texture.get_size()
        size.x -= padding_left + padding_right
        size.y -= padding_top + padding_bottom
        size.x -= spacing * (columns - 1)
        size.y -= spacing * (rows - 1)
        size.x /= columns
        size.y /= rows
        
        tileset.columns = columns
        while tileset.tiles.size() > count:
            tileset.remove_tile(tileset.tiles[0])
        
        while tileset.tiles.size() < count:
            var atlas_texture = AtlasTexture.new()
            atlas_texture.atlas = texture_rect.texture
            
            var tile = TILE_SCENE.instance()
            tile.texture = atlas_texture
            tileset.add_tile(tile)
        
        for y in range(rows):
            for x in range(columns):
                var i = x + y * columns
                var tile = tileset.tiles[i]
                var rx = padding_left + x * size.x + x * spacing
                var ry = padding_top + y * size.y + y * spacing
                var rwidth = size.x
                var rheight = size.y
                tile.name = "Tile (" + String(x) + ", " + String(y) + ")"
                tile.texture.region = Rect2(rx, ry, rwidth, rheight)

func download_image():
    $HTTPRequest.request($Main/VBoxContainer/DownloadPanel/TextEdit.text)

func download_complete(_result, _response_code, _headers, body):
    var image = Image.new()
    var image_error = image.load_png_from_buffer(body)
    if image_error != OK:
        image_error = image.load_jpg_from_buffer(body)
    if image_error != OK:
        image_error = image.load_webp_from_buffer(body)
    if image_error != OK:
        print("An error occurred while trying to display the image.")

    texture = ImageTexture.new()
    texture.create_from_image(image)

    texture_rect.texture = texture
    $Main/VBoxContainer/DownloadPanel.visible = false
    $Main/VBoxContainer/ImagePanel.visible = true
    ok_button.disabled = false

func emit_texture_loaded():
    $Main.visible = false
    emit_signal("texture_loaded")

func emit_cancelled():
    reset()
    $Main.visible = false
    emit_signal("cancelled")

func reset():
    url = null
    texture = null
    columns = -1
    rows = -1
    padding_top = -1
    padding_right = -1
    padding_bottom = -1
    padding_left = -1
    spacing = -1

func show_highlight_columns():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/columns.visible = true

func hide_highlight_columns():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/columns.visible = false

func show_highlight_rows():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/rows.visible = true

func hide_highlight_rows():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/rows.visible = false

func show_highlight_spacing():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/spacing.visible = true

func hide_highlight_spacing():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/spacing.visible = false

func show_highlight_padding():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/padding.visible = true

func hide_highlight_padding():
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/Panel/padding.visible = false

func populate_other_paddings():
    if padding_right_field.text == padding_bottom_field.text \
    and padding_bottom_field.text == padding_left_field.text:
        var value = padding_top_field.text
        padding_right_field.text = value
        padding_bottom_field.text = value
        padding_left_field.text = value
