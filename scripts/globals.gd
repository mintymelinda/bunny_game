extends Node

var loading_screen = preload("res://scenes/loading_screen.tscn")
var next_scene: String = "res://scenes/loading_screen.tscn"






func change_scene_to(scene: String, callback):
	next_scene = scene
	var loading = loading_screen.instantiate()
	loading.scene_loaded.connect(callback)
	if not loading.get_parent():
		add_child(loading)
