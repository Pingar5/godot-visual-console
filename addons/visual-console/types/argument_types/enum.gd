extends ConsoleArgument

var options: Array

func _init(data: Dictionary = {}).(data) -> void:
	if data.has("options"):
		options = data.options
	else:
		Console.write_error("Enum arguments must have a list of options provided")

func get_editor_scene() -> PackedScene:
	return preload("res://addons/visual-console/components/argument_editors/OptionSetArgumentEditor.tscn")

func get_default_value() -> int:
	return 0

func get_options() -> Array:
	var option_set: Array = []
	
	for option_index in len(options):
		option_set.append({
			"name": options[option_index],
			"value": option_index
		})
	
	return option_set
