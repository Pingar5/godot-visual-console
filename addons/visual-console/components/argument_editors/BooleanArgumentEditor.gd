extends CheckBox

var argument: ConsoleArgument

func display_argument(argument: ConsoleArgument) -> void:
	self.argument = argument
	text = argument.name
	pressed = argument.value

func on_toggled(new_value: bool) -> void:
	argument.value = new_value

func focus_primary_input() -> void:
	grab_focus()
