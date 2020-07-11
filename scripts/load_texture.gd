#warning-ignore-all: return_value_discarded
extends Control

func _ready():
    $Main/VBoxContainer/DownloadPanel/Button.connect("pressed", self, "download_image")
    $HTTPRequest.connect("request_completed", self, "download_complete")

    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Columns.connect("focus_entered", self, "show_highlight_columns")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Columns.connect("focus_exited", self, "hide_highlight_columns")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Rows.connect("focus_entered", self, "show_highlight_rows")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Rows.connect("focus_exited", self, "hide_highlight_rows")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Spacing.connect("focus_entered", self, "show_highlight_spacing")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Spacing.connect("focus_exited", self, "hide_highlight_spacing")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Padding.connect("focus_entered", self, "show_highlight_padding")
    $Main/VBoxContainer/SettingsPanel/HBoxContainer/GridContainer/Padding.connect("focus_exited", self, "hide_highlight_padding")

func download_image():
    $HTTPRequest.request($Main/VBoxContainer/DownloadPanel/TextEdit.text)

func download_complete(_result, _response_code, _headers, body):
    var image = Image.new()
    var image_error = image.load_png_from_buffer(body)
    if image_error != OK:
        print("An error occurred while trying to display the image.")

    var texture = ImageTexture.new()
    texture.create_from_image(image)

    $Main/VBoxContainer/ImagePanel/TextureRect.texture = texture
    $Main/VBoxContainer/DownloadPanel.visible = false
    $Main/VBoxContainer/ImagePanel.visible = true

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
