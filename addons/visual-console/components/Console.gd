extends CanvasLayer

var SELECT_BB_TAGS: = RegEx.new()

signal opened
signal closed
signal command_list_changed


var visible : bool setget, get_visible

var root_panel: Panel
var output_text: RichTextLabel
var command_palette
var animation_player: AnimationPlayer
var root_folder : ConsoleFolder = ConsoleFolder.new("root", null)
var targets := []

func _ready() -> void:
	root_panel = ConsoleSettings.get_current_layout_scene().instance()
	add_child(root_panel)
	
	output_text = root_panel.get_node("OutputText")
	command_palette = root_panel.get_node("CommandPalette")
	animation_player = root_panel.get_node("AnimationPlayer")
	
	SELECT_BB_TAGS.compile('\\[[\\/]?[a-z0-9\\=\\#\\ \\_\\-\\,\\.\\;]+\\]')
	
	write_line(ProjectSettings.get_setting("application/config/name")) 
	
	var engine_version: = Engine.get_version_info()
	write_line("Godot " + str(engine_version.major) + "." + str(engine_version.minor) + "." + str(engine_version.patch) + " " + engine_version.status + "\n")
	
	register_default_commands()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console_toggle"):
		toggle_visibility()
		get_tree().set_input_as_handled()

func add_command(id: String, target, method_name : String, arguments := {}):
	var path := Array(id.split("/", false))
	var command_name: String = path.pop_back()
	
	var built_arguments := []
	for argument_name in arguments:
		var argument_data = arguments[argument_name]
		built_arguments.append(ConsoleArgument.build(argument_name, argument_data))
	
	if target is Object:
		root_folder.add_command(path, SpecificTargetConsoleCommand.new(command_name, target, method_name, built_arguments))
	elif target is Array:
		root_folder.add_command(path, DynamicTargetConsoleCommand.new(command_name, target, method_name, built_arguments))
	else:
		write_error("Invalid command. Target must be an object or an array of tags")
	emit_signal("command_list_changed")

func remove_command(id: String) -> void:
	var path := Array(id.split("/", false))
	var command_name: String = path.pop_back()
	root_folder.remove_command(path, command_name)
	emit_signal("command_list_changed")

func add_target(name: String, target: Object, tags: Array = [], auto_remove: bool = true) -> void:
	for existing_target in targets:
		if existing_target.get_target() == target:
			write_error("Target is already registered under name %s" % existing_target.name)
			return
	
	targets.append(ConsoleTarget.new(name, target, tags))
	
	if target is Node and auto_remove:
		target.connect("tree_exiting", self, "remove_target", [target])

func remove_target(target: Object) -> void:
	for target_index in len(targets):
		if targets[target_index].target.get_ref() == target:
			targets.remove(target_index)
			return

func write_line(line, color: Color = Color.white, include_stack: bool = false) -> void:
	write(str(line) + "\n", color, include_stack)

func write(text, color: Color = Color.white, include_stack: bool = false) -> void:
	_write(str(text), include_stack, color, ConsoleSettings.WriteLevel.INFO, true)

func write_bbcode(text: String) -> void:
	output_text.append_bbcode(text)
	print(SELECT_BB_TAGS.sub(text, "", true).strip_edges(false, true))

func write_error(error: String, include_stack: bool = true) -> void:
	push_error(error)
	var error_color : Color = ConsoleSettings.get_setting("error_color")
	error = "ERROR: " + error + "\n"
	_write(error, include_stack, error_color, ConsoleSettings.WriteLevel.ERROR, false)

func write_warning(warning: String, include_stack: bool = true) -> void:
	push_warning(warning)
	var warning_color : Color = ConsoleSettings.get_setting("warning_color")
	warning = "WARNING: " + warning + "\n"
	_write(warning, include_stack, warning_color, ConsoleSettings.WriteLevel.WARNING, false)

func _write(text: String, include_stack: bool, color: Color, level: int, print_to_output: bool) -> void:
	output_text.append_bbcode("[color=#%s]%s[/color]\n" % [color.to_html(), text.strip_edges(false, true)])
	
	if include_stack:
		var stack_trace := _convert_stack_to_bbcode(get_stack(), color)
		output_text.append_bbcode(stack_trace)
		text += SELECT_BB_TAGS.sub(stack_trace, "", true)
	
	var write_levels_to_consider_failure : int = ConsoleSettings.get_setting("write_levels_to_consider_failure")
	command_palette.command_is_successful = command_palette.command_is_successful and \
		not level & write_levels_to_consider_failure
	
	if print_to_output:
		print(text.strip_edges(false, true))

func _convert_stack_to_bbcode(stack_frames: Array, color: Color) -> String:
	var bbcode : String = ""
	
	for stack_frame in stack_frames.slice(1, len(stack_frames) - 1):
		var stack_frame_text = "	%s:%d (in %s)" % [stack_frame["source"], stack_frame["line"], stack_frame["function"]]
		bbcode += "[color=#%s]%s[/color]\n" % [color.to_html(false), stack_frame_text]
	
	return bbcode

func close() -> void:
	if self.visible:
		toggle_visibility()

func get_visible() -> bool:
	return root_panel.visible

func toggle_visibility() -> void:
	if self.visible:
		animation_player.play("close")
		emit_signal("closed")
	else:
		animation_player.play("open")
		emit_signal("opened")


###################################
# Default command implementations #
###################################

func register_default_commands() -> void:
	add_command("clear_console_output", self, "clear")
	add_command("debug/set_time_scale", self, "set_time_scale", {
		"Time scale": {
			"type": "float",
			"min_value": 0.0
		}
	})
	
	add_command("window/set_target_framerate", self, "set_target_fps", {
		"Target FPS": {
			"type": "int",
			"min_value": 1
		}
	})
	
	add_command("audio/mute_bus", self, "mute_audio_bus", {
		"Bus ID": "audio_bus"
	})
	
	add_command("debug/toggle_collision_display", self, "toggle_visible_collision_shapes")

func clear() -> void:
	output_text.clear()

func toggle_visible_collision_shapes() -> void:
	Console.get_tree().debug_collisions_hint = not Console.get_tree().debug_collisions_hint
	Console.write_line("Collision shapes will " + ("now" if Console.get_tree().debug_collisions_hint else "no longer") + " be shown. (Takes effect on new scene load)")

func mute_audio_bus(bus_id: int) -> void:
	var bus_is_muted := AudioServer.is_bus_mute(bus_id)
	
	AudioServer.set_bus_mute(bus_id, not bus_is_muted)
	Console.write_line(AudioServer.get_bus_name(bus_id) + " sounds are now " + ("unmuted" if bus_is_muted else "muted"))

func set_time_scale(time_scale: float) -> void:
	Engine.time_scale = time_scale
	Console.write_line("Time scale is now: %f" % time_scale)

func set_target_fps(target_fps: int) -> void:
	Engine.target_fps = target_fps
	Console.write_line("Target FPS is now: %d" % target_fps)
