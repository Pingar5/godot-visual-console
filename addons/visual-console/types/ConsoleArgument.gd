extends Reference
class_name ConsoleArgument

var name: String
var value setget set_value, get_value
var default_value

static func build(name, data) -> ConsoleArgument:
	var argument_type: Script
	if data is String:
		argument_type = get_argument_type_script(data)
		data = {
			"name": name,
			"type": data
		}
	else:
		argument_type = get_argument_type_script(data.type)
		data["name"] = name
	
	return argument_type.new(data)

static func get_argument_type_script(type_name: String) -> Script:
	var plugin_path: String = ConsoleSettings.get_setting("plugin_path")
	return load(plugin_path.plus_file("types/argument_types/%s.gd" % type_name)) as Script

func _init(data := {}) -> void:
	name = data.name
	self.default_value = data.default_value if data.has("default_value") else get_default_value()
	self.value = self.default_value

func get_default_value():
	return null

func reset_to_default_value() -> void:
	self.value = self.default_value

func set_value(new_value) -> void:
	value = new_value

func get_value():
	return value

func get_editor_scene() -> PackedScene:
	return null

# Used for option set editor, should return an array of dictionaries with the following format:
# {
# 	"name": String
# 	"value: Variant (this is what the argument will be set to)
# }
func get_options() -> Array:
	return []
