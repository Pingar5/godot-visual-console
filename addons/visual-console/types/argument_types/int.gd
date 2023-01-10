extends ConsoleArgument

const precision := 0
var min_value: int = -pow(2, 63)
var max_value: int = pow(2, 62)

func _init(data: Dictionary = {}).(data) -> void:
	min_value = data.min_value if data.has("min_value") else min_value
	max_value = data.max_value if data.has("max_value") else max_value

func get_editor_scene() -> PackedScene:
	return preload("res://addons/visual-console/components/argument_editors/NumberArgumentEditor.tscn")

func get_default_value() -> int:
	return 0

