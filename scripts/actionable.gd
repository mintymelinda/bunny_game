extends Area3D

@export var dialog_resource: DialogueResource
@export var dialog_start: String

func action() -> void:
	DialogueManager.show_dialogue_balloon(dialog_resource, dialog_start)
