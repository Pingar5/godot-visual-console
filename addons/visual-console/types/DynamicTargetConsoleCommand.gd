extends ConsoleCommand
class_name DynamicTargetConsoleCommand

var valid_target_tags: Array
var target_argument: ConsoleArgument

func _init(name: String, valid_target_tags: Array, method_name: String, arguments: Array = []).(name, method_name, arguments) -> void:
	self.valid_target_tags = valid_target_tags
	target_argument = ConsoleArgument.build("Target", {
		"type": "target",
		"valid_target_tags": valid_target_tags
	})

func should_execute_immediately() -> bool:
	return false

func get_arguments() -> Array:
	return [target_argument] + arguments

func get_target():
	return target_argument.value
