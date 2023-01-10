extends HBoxContainer

onready var value_input : SpinBox = $SpinBox

var argument: ConsoleArgument

func display_argument(argument: ConsoleArgument) -> void:
	self.argument = argument
	$Label.text = argument.name
	
	var value = argument.value
	value_input.step = 1 / pow(10, argument.precision)
	value_input.min_value = argument.min_value
	value_input.max_value = argument.max_value
	value_input.value = value

func on_value_changed(value: float) -> void:
	argument.value = value

func focus_primary_input() -> void:
	value_input.get_line_edit().grab_focus()
	value_input.get_line_edit().select()

func on_focus_entered() -> void:
	focus_primary_input()
