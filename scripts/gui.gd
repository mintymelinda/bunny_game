extends Control

func _ready() -> void:
	$Retry.hide()

func _on_player_jump() -> void:
	$Accent/ComboLabel._on_ground_touched()

func _on_player_moved(pos) -> void:
	$Accent/PositionLabel._on_position_updated(pos)

func _on_player_select_power_up(power_up) -> void:
	$Accent/PowerUpLabel._on_updated(power_up)


func _on_player_ate(combo: Variant) -> void:
	$Accent/ScoreLabel._on_food_eaten(combo)
	$Accent/ComboLabel._on_food_eaten()
