class_name RulesNew
extends Node

var left = []
var right = []
var top = []
var bottom = []

onready var rule_viewer = $RuleViewer

# warning-ignore:shadowed_variable
static func show_rule(rules, tileset, tile):
# warning-ignore:shadowed_variable
    var rule_viewer = rules.rule_viewer
    for child in rule_viewer.get_children():
        NodeExt.delete_all_children(child)
    
    var tile_node = TileNode.set_tile(TileNode.new(), tile)
    NodeExt.replace(rules.rule_viewer.main, tile_node)
    rule_viewer.main = tile_node
    connect_press_to_tileset(rules, tileset)
    
    for direction in ["left", "right", "top", "bottom"]:
        for rule in rules[direction]:
            if rule[0] == tile.id:
                var other_tile = Tileset.get_tile_by_id(tileset, rule[1])
                var rule_tile_node = TileNode.new()
                TileNode.set_tile(rule_tile_node, other_tile)
                NodeExt.add_child(rule_viewer[direction], rule_tile_node)
        GridContainerExt.square_off(rule_viewer[direction])
    
    rules.show()
    return rules

static func can_be_neighbor(rules, slot, direction, neighbor):
    return rules[direction].has([slot, neighbor])

# warning-ignore:shadowed_variable
static func connect_press_to_tileset(rules, tileset):
    var main = rules.convert_rule_viewer_main_to_button(rules)
    main.connect("pressed", tileset, "show")
    main.connect("pressed", rules, "disconnect_and_hide", [main, rules, tileset])

# warning-ignore:shadowed_variable
static func disconnect_and_hide(main, rules, tileset):
    rules.hide()
    main.disconnect("pressed", tileset, "show")
    main.disconnect("pressed", rules, "disconnect_and_hide")

# warning-ignore:shadowed_variable
static func convert_rule_viewer_main_to_button(rules):
    var main = rules.rule_viewer.main
    var main_button = TileButtonNode.new()
    main_button.set_tile(main_button, main.tile)
    NodeExt.replace(main, main_button)
    rules.rule_viewer.main = main_button
    return main_button
