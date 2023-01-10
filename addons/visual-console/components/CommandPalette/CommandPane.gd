extends Control

signal cancelled
signal submitted

onready var name_label : Label = $Title/Name
onready var arguments_container : VBoxContainer = $Arguments/VBoxContainer

var current_command : ConsoleCommand

func clear_display() -> void:
	for child in arguments_container.get_children():
		child.queue_free()

func display_command(command: ConsoleCommand) -> void:
	return
	clear_display()
	current_command = command
	
	name_label.text = command.name.capitalize()
	
	var first_argument : Node = null
	for argument in command.arguments:
		var argument_instance = argument.get_editor_scene().instance()
		arguments_container.add_child(argument_instance)
		argument_instance.display_argument(argument)
		
		if not first_argument:
			first_argument = argument_instance
	
	first_argument.focus_primary_input()
	

func on_cancel_pressed() -> void:
	emit_signal("cancelled")

func on_submit_pressed() -> void:
	emit_signal("submitted", current_command)
