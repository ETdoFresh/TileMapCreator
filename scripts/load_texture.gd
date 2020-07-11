#warning-ignore-all: return_value_discarded
extends Control

func _ready():
    $Main/VBoxContainer/DownloadPanel/Button.connect("pressed", self, "download_image")
    $HTTPRequest.connect("request_completed", self, "download_complete")

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
