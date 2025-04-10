extends DirectionalLight3D

@export var speed: float = 0.03

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#rotate_x(-PI / 2)
	pass

func _process(delta: float) -> void:
	pass
	#rotate_x(2 * PI * delta * speed)
