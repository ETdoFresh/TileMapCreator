class_name KeyboardShortcuts

static func restart_on_ctrl_r(scene_tree: SceneTree):
    if Input.is_action_just_pressed("reset"):
        if Input.is_key_pressed(KEY_CONTROL):
            var _1 = scene_tree.change_scene_to(Scene.INTRO_CREDITS)

static func scene_menu_on_ctrl_m(scene_tree: SceneTree):
    if Input.is_action_just_pressed("scene_menu"):
        if Input.is_key_pressed(KEY_CONTROL):
            var _1 = scene_tree.change_scene_to(Scene.SCENE_MENU)
