extends Node2D

var rules_right = [] # [0] has a right neighbor of [1]
var rules_left = [] # [0] has a left neighbor of [1]
var rules_top = [] # [0] has a top neighbor of [1]
var rules_bottom = [] # [0] has a bottom neighbor of [1]

func _ready():
    for x in range(0, 100, 3):
        if $RulesRight.get_cell(x, 0) != -1:
            for y in range (100):
                if $RulesRight.get_cell(x, y) != -1:
                    rules_right.append([$RulesRight.get_cell(x, y), $RulesRight.get_cell(x + 1, y)])
    
    for x in range(0, 100, 3):
        if $RulesLeft.get_cell(x, 0) != -1:
            for y in range (100):
                if $RulesLeft.get_cell(x, y) != -1:
                    rules_left.append([$RulesLeft.get_cell(x + 1, y), $RulesLeft.get_cell(x, y)])
    
    for y in range(0, 100, 3):
        if $RulesTop.get_cell(0, y) != -1:
            for x in range (100):
                if $RulesTop.get_cell(x, y) != -1:
                    rules_top.append([$RulesTop.get_cell(x, y + 1), $RulesTop.get_cell(x, y)])
    
    for y in range(0, 100, 3):
        if $RulesBottom.get_cell(0, y) != -1:
            for x in range (100):
                if $RulesBottom.get_cell(x, y) != -1:
                    rules_bottom.append([$RulesBottom.get_cell(x, y), $RulesBottom.get_cell(x, y + 1)])
