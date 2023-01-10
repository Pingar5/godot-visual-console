extends HBoxContainer

onready var value_input : OptionButton = $OptionButton

var option_set: Array

var argument: ConsoleArgument

func display_argument(argument: ConsoleArgument) -> void:
	self.argument = argument
	$Label.text = argument.name
	
	option_set = argument.get_options()
	
	for item_index in value_input.get_item_count():
		value_input.remove_item(item_index)
	
	for option in option_set:
		value_input.add_item(option.name)
	
	if value_input.selected != -1:
		argument.value = option_set[value_input.selected].value

func on_item_selected(index: int) -> void:
		argument.value = option_set[index].value

func focus_primary_input() -> void:
	value_input.grab_focus()
