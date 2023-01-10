extends ConsoleArgument

func _init(data: Dictionary = {}).(data) -> void:
	pass

func get_editor_scene() -> PackedScene:
	return preload("res://addons/visual-console/components/argument_editors/BooleanArgumentEditor.tscn")

func get_default_value() -> bool:
	return false
