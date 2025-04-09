extends Label


var score = 0
@export var mult = 100

func _on_food_eaten(combo):
	score += combo * mult
	text = "Score: %s" % score

func _on_splashed():
	score = 0
	
