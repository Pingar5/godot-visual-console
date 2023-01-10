extends ConsoleArgument

func _init(data: Dictionary = {}).(data) -> void:
	pass

func get_editor_scene() -> PackedScene:
	return preload("res://addons/visual-console/components/argument_editors/OptionSetArgumentEditor.tscn")

func get_options() -> Array:
	var option_set: Array = []
	
	for bus_id in AudioServer.bus_count:
		option_set.append({
			"name": AudioServer.get_bus_name(bus_id),
			"value": bus_id
		})
	
	return option_set
