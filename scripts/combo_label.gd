extends Label

@export var max_combo = 5

var combo = 0

func _on_food_eaten():
	combo = min(combo + 1, max_combo)
	text = "Combo: %s" % combo

func _on_ground_touched():
	combo = max(combo - 1, 0)
	text = "Combo: %s" % combo
