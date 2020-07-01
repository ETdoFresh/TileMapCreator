class_name Rules
extends Node2D

var rules = \
{
    "top": [],
    "right": [],
    "bottom": [],
    "left": [],
}

func _ready():
    for x in range(0, 100, 3):
        if $RulesRight.get_cell(x, 0) != -1:
            for y in range (100):
                if $RulesRight.get_cell(x, y) != -1:
                    rules.right.append([$RulesRight.get_cell(x, y), $RulesRight.get_cell(x + 1, y)])
    
    for x in range(0, 100, 3):
        if $RulesLeft.get_cell(x, 0) != -1:
            for y in range (100):
                if $RulesLeft.get_cell(x, y) != -1:
                    rules.left.append([$RulesLeft.get_cell(x + 1, y), $RulesLeft.get_cell(x, y)])
    
    for y in range(0, 100, 3):
        if $RulesTop.get_cell(0, y) != -1:
            for x in range (100):
                if $RulesTop.get_cell(x, y) != -1:
                    rules.top.append([$RulesTop.get_cell(x, y + 1), $RulesTop.get_cell(x, y)])
    
    for y in range(0, 100, 3):
        if $RulesBottom.get_cell(0, y) != -1:
            for x in range (100):
                if $RulesBottom.get_cell(x, y) != -1:
                    rules.bottom.append([$RulesBottom.get_cell(x, y), $RulesBottom.get_cell(x, y + 1)])

func can_be_neighbor(slot, direction, neighbor):
    for rule in rules[direction]:
        if rule[0] == slot:
            if rule[1] == neighbor:
                return true
    return false
