var entropy = INF
var x = -1
var y = -1
var tiles = []
var top = null
var bottom = null
var left = null
var right = null

func duplicate():
    var duplicate = get_script().new()
    duplicate.entropy = entropy
    duplicate.x = x
    duplicate.y = y
    duplicate.tiles = tiles.duplicate()
    duplicate.top = top
    duplicate.bottom = bottom
    duplicate.left = left
    duplicate.right = right
    return duplicate
