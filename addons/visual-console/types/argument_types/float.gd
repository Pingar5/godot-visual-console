extends ConsoleArgument

var precision: int = 4
var min_value: float = -INF
var max_value: float = INF

func _init(data: Dictionary = {}).(data) -> void:
	precision = data.precision if data.has("precision") else precision
	min_value = data.min_value if data.has("min_value") else min_value
	max_value = data.max_value if data.has("max_value") else max_value

func get_editor_scene() -> PackedScene:
	return preload("res://addons/visual-console/components/argument_editors/NumberArgumentEditor.tscn")

func get_default_value() -> float:
	return 0.0
