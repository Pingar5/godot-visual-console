extends ConsoleArgument

var valid_target_tags: Array

func _init(data: Dictionary = {}).(data) -> void:
	valid_target_tags = data.valid_target_tags if data.has("valid_target_tags") else []

func get_editor_scene() -> PackedScene:
	return preload("res://addons/visual-console/components/argument_editors/OptionSetArgumentEditor.tscn")

func get_options() -> Array:
	var all_valid_targets: Array
	var option_set: Array = []
	
	for tag in valid_target_tags:
		for target in Console.targets:
			if target.has_tag(tag):
				option_set.append({
					"name": target.name,
					"value": target
				})
				all_valid_targets.append(target.get_target())
	
	option_set.push_front({
		"name": "All",
		"value": ConsoleMultiTarget.new(all_valid_targets)
	})
	
	return option_set
