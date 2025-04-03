extends AreaBase

signal eaten

@export var animation_speed = 1.0

func initialize(g):
	super(g)
	
	blocking_types = ["food", "water", "tree", "rock", "spawn", "house"]
	
	set_random_rotate_y()
	set_random_placement()
	
	$AnimationPlayer.speed_scale = animation_speed
	$AnimationPlayer.stop()

func eat(combo):
	for index in range(combo):
		eaten.emit()
	$AnimationPlayer.play("grow")
	$SpoilTimer.start()
	
func _on_spoil_timer_timeout() -> void:
	ground.remove(self)
	queue_free()
