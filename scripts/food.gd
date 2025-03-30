extends AreaBase

signal eaten

@export var animation_speed = 1.0

func initialize(canopy, blocking_groups = null):
	super(canopy, blocking_groups)
	
	set_random_placement()
	set_random_rotate_y()
	
	$AnimationPlayer.speed_scale = animation_speed
	$AnimationPlayer.stop()
	
func eat(combo):
	for index in range(combo):
		eaten.emit()
	$AnimationPlayer.play("grow")
	$SpoilTimer.start()
	
func _on_spoil_timer_timeout() -> void:
	surface.remove(self)
	queue_free()
