tool
class_name ConsoleSettings

enum ShiftExecuteBehavior {
	RESET_ARGUMENTS,
	USE_LAST_ARGUMENTS
}

enum WriteLevel {
	INFO = 1,
	WARNING = 2,
	ERROR = 4
}

enum LayoutType {
	DESKTOP,
	MOBILE,
	PIXEL
}

const LAYOUT_SCENE_PATHS := {
	LayoutType.DESKTOP: "components/ConsoleDesktopLayout.tscn",
	LayoutType.MOBILE: "components/ConsoleMobileLayout.tscn",
	LayoutType.PIXEL: "components/ConsolePixelLayout.tscn"
}

const SETTINGS := {
	"plugin_path": {
		"default_value": "res://addons/visual-console/",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR,
		"hint_string": ""
	},
	"layout": {
		"default_value": LayoutType.DESKTOP,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"enum": LayoutType
	},
	"theme": {
		"default_value": "res://addons/visual-console/HighResTheme.tres",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tres"
	},
	"focus_search_bar_on_open": {
		"default_value": true,
		"type": TYPE_BOOL
	},
	"close_console_after_successful_command": {
		"default_value": true,
		"type": TYPE_BOOL
	},
	"write_levels_to_consider_failure": {
		"default_value": WriteLevel.WARNING | WriteLevel.ERROR,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"enum": WriteLevel
	},
	"shift_execute_behavior": {
		"default_value": ShiftExecuteBehavior.RESET_ARGUMENTS,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"enum": ShiftExecuteBehavior
	},
	"error_color": {
		"default_value": Color("FF0000"),
		"type": TYPE_COLOR
	},
	"warning_color": {
		"default_value": Color("D78422"),
		"type": TYPE_COLOR
	}
}


static func get_setting(setting_id: String):
	if setting_id.begins_with("console/"):
		setting_id = setting_id.substr(8)
	
	var setting_name = "console/" + setting_id
	if ProjectSettings.has_setting(setting_name):
		return ProjectSettings.get_setting(setting_name)
	else:
		return SETTINGS[setting_id]["default_value"]

static func get_hint_string_for_enum(target_enum) -> String:
	var keys = target_enum.keys()
	var hint_string = ""
	var is_first = true
	
	for key in keys:
		hint_string += ("" if is_first else ",") + key.to_lower().capitalize()
		is_first = false
	
	return hint_string

static func get_current_layout_scene() -> PackedScene:
	var layout_file_path : String = LAYOUT_SCENE_PATHS[get_setting("layout")]
	var plugin_path : String = get_setting("plugin_path")
	var layout_scene_path : String = plugin_path.plus_file(layout_file_path)
	return load(layout_scene_path) as PackedScene
