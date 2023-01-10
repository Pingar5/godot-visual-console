extends HBoxContainer

onready var value_input : LineEdit = $LineEdit

var argument: ConsoleArgument

func display_argument(argument: ConsoleArgument) -> void:
	self.argument = argument
	$Label.text = argument.name
	value_input.text = argument.value

func on_text_changed(new_text: String) -> void:
	argument.value = new_text

func focus_primary_input() -> void:
	value_input.grab_focus()
