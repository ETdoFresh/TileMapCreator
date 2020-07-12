#warning-ignore-all: return_value_discarded
extends Control

signal texture_loaded
signal cancelled

var url = null
var texture = null
var columns = -1
var rows = -1
var padding = -1
var spacing = -1

onready var ok_button = $Main/VBoxContainer/ButtonPanel/HBoxContainer/OK
onready var cancel_button = $Main/VBoxContainer/ButtonPanel/HBoxContainer/Cancel
onready var columns_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Columns
onready var rows_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Rows
onready var padding_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Padding
onready var spacing_field = $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Spacing
onready var texture_rect = $Main/VBoxContainer/ImagePanel/VBoxContainer/HBoxContainer/TextureRect
onready var grid = $Main/VBoxContainer/ImagePanel/VBoxContainer/HBoxContainer/GridContainer

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
    padding_field.connect("focus_entered", self, "show_highlight_padding")
    padding_field.connect("focus_exited", self, "hide_highlight_padding")
    spacing_field.connect("focus_entered", self, "show_highlight_spacing")
    spacing_field.connect("focus_exited", self, "hide_highlight_spacing")

func _process(_delta):
    if $Main/VBoxContainer/ImagePanel.visible:
        if not texture_rect.texture: return
        if not columns_field.text.is_valid_integer(): return
        if not rows_field.text.is_valid_integer(): return
        if not padding_field.text.is_valid_integer(): return
        if not spacing_field.text.is_valid_integer(): return
        
        var columns = int(columns_field.text)
        var rows = int(rows_field.text)
        var padding = int(padding_field.text)
        var spacing = int(spacing_field.text)
        
        if columns <= 0: return
        if rows <= 0: return
        if padding < 0: return
        if spacing < 0: return
        
        var count = rows * columns
        var size = texture_rect.texture.get_size()
        size.x -= padding * 2
        size.y -= padding * 2
        size.x -= spacing * (columns - 1)
        size.y -= spacing * (rows - 1)
        size.x /= columns
        size.y /= rows
        
        grid.columns = columns
        while grid.get_child_count() > count:
            grid.remove_child(grid.get_child(0))
        
        while grid.get_child_count() < count:
            var panel = Panel.new()
            panel.self_modulate = Color.orange
            panel.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL
            panel.size_flags_vertical = TextureRect.SIZE_EXPAND_FILL
            var texture = TextureRect.new()
            texture.expand = true
            texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
            var atlas_texture = AtlasTexture.new()
            atlas_texture.atlas = texture_rect.texture
            texture.texture = atlas_texture
            texture.anchor_bottom = 1
            texture.anchor_right = 1
            grid.add_child(panel)
            panel.add_child(texture)
        
        for y in range(rows):
            for x in range(columns):
                var i = x + y * columns
                var cell = grid.get_child(i).get_child(0)
                var rx = padding + x * size.x + x * spacing
                var ry = padding + y * size.y + y * spacing
                var rwidth = size.x
                var rheight = size.y
                cell.name = "Cell (" + String(x) + ", " + String(y) + ")"
                cell.texture.region = Rect2(rx, ry, rwidth, rheight)

func download_image():
    $HTTPRequest.request($Main/VBoxContainer/DownloadPanel/TextEdit.text)

func download_complete(_result, _response_code, _headers, body):
    var image = Image.new()
    var image_error = image.load_png_from_buffer(body)
    if image_error != OK:
        print("An error occurred while trying to display the image.")

    var texture = ImageTexture.new()
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
    emit_signal("texture_loaded")

func reset():
    url = null
    texture = null
    columns = -1
    rows = -1
    padding = -1
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
