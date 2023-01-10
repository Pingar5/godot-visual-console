tool
extends EditorPlugin

const AUTOLOAD_NAME := "Console"

const INPUT_ACTIONS := [
	{
		"name": "console_toggle",
		"scancode": KEY_QUOTELEFT
	},
	{
		"name": "console_skip_arguments",
		"scancode": KEY_SHIFT
	}
]



func _enter_tree() -> void:
	var plugin_path: String = get_script().resource_path.trim_suffix("plugin.gd")
	
	for setting_id in ConsoleSettings.SETTINGS:
		var setting: Dictionary = ConsoleSettings.SETTINGS[setting_id]
		var setting_name: String = "console/" + setting_id
		if not ProjectSettings.has_setting(setting_name):
			ProjectSettings.set_setting(setting_name, setting["default_value"])
			ProjectSettings.set_initial_value(setting_name, setting["default_value"])
			
			var hint = setting["hint"] if setting.has("hint") else null
			var hint_string = setting["hint_string"] if setting.has("hint_string") else null
			
			if hint and hint in [PROPERTY_HINT_ENUM, PROPERTY_HINT_FLAGS]:
				hint_string = ConsoleSettings.get_hint_string_for_enum(setting["enum"])
			
			ProjectSettings.add_property_info({
				"name": setting_name,
				"type": setting["type"],
				"hint": hint,
				"hint_string": hint_string
			})
	
	for action in INPUT_ACTIONS:
		var setting_name : String = "input/" + action["name"]
		
		if not ProjectSettings.has_setting(setting_name):
			var event = InputEventKey.new()
			event.set("scancode", action["scancode"])
			
			ProjectSettings.set_setting(setting_name, {
				"events": [event],
				"deadzone": 0.5
			})
	ProjectSettings.save()
	
	add_autoload_singleton(AUTOLOAD_NAME, plugin_path.plus_file("components/Console.tscn"))

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
