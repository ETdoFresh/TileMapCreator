extends Control

const MAX_LINES = 250

var lines = []
var panel: Panel
var vbox: VBoxContainer
var scroll_container: ScrollContainer
var console: Label
var command_prompt: LineEdit

onready var root = get_tree().root

func _ready():
    rect_size = Vector2(1920, 1080)
    _create_panel()
    _create_console()
    _create_command_prompt()

func _process(_delta):
    if Input.is_action_just_pressed("in_game_console"):
        if panel.is_inside_tree():
            command_prompt.release_focus()
            command_prompt.text = command_prompt.text.replace("`", "")
            root.remove_child(panel)
        else:
            root.add_child(panel)
            command_prompt.grab_focus()
            command_prompt.caret_position = command_prompt.text.length()
            yield(get_tree(), "idle_frame")
            scroll_container.scroll_vertical = int(scroll_container.get_v_scrollbar().max_value)

func println(text):
    print(text)
    lines.append(text)
    
    while lines.size() > MAX_LINES:
        lines.pop_front()
    
    var console_text = ""
    for i in range(lines.size()):
        if i == 0: console_text = lines[i]
        else: console_text += "\n" + lines[i]
    console.text = console_text
    
    yield(get_tree(), "idle_frame")
    scroll_container.scroll_vertical = int(scroll_container.get_v_scrollbar().max_value)

func _create_panel():
    panel = Panel.new()
    panel.rect_size = Vector2(1280, 720)
    panel.self_modulate.a = 0.75
    vbox = VBoxContainer.new()
    vbox.rect_size = panel.rect_size
    panel.add_child(vbox)

func _create_console():
    scroll_container = ScrollContainer.new()
    scroll_container.size_flags_horizontal = SIZE_EXPAND_FILL
    scroll_container.size_flags_vertical = SIZE_EXPAND_FILL
    vbox.add_child(scroll_container)
    console = Label.new()
    console.size_flags_horizontal = SIZE_EXPAND_FILL
    console.size_flags_vertical = SIZE_EXPAND_FILL
    console.valign = Label.VALIGN_BOTTOM
    scroll_container.add_child(console)

func _create_command_prompt():
    command_prompt = LineEdit.new()
    command_prompt.size_flags_horizontal = SIZE_EXPAND_FILL
    var _1 = command_prompt.connect("text_entered", self, "_print_and_clear_command_prompt")
    vbox.add_child(command_prompt)

func _print_and_clear_command_prompt(text):
    println(text)
    _clear_command_prompt()

func _clear_command_prompt():
    command_prompt.text = ""
