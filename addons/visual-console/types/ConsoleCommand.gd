extends ConsoleListing
class_name ConsoleCommand

var method_name: String
var arguments: Array setget, get_arguments

func _init(name: String, method_name: String, arguments: Array).(name) -> void:
	self.method_name = method_name
	self.arguments = arguments

func should_execute_immediately() -> bool:
	return len(arguments) == 0

func get_target():
	return null

func execute() -> void:
	var argument_values := []
	
	for argument in arguments:
		argument_values.append(argument.value)
	
	var target = get_target()
	if not target:
		Console.write_error("Failed to get target")
	elif target is ConsoleMultiTarget:
		var individual_targets: Array = target.get_targets()
		
		if len(individual_targets) == 0:
			Console.write_error("There are no valid targets for this command")
		
		for individual_target in individual_targets:
			individual_target.callv(method_name, argument_values)
	elif target is ConsoleTarget:
		var unwrapped_target: Node = target.get_target()
		
		if unwrapped_target == null:
			Console.write_error("Command target is no longer valid")
		
		unwrapped_target.callv(method_name, argument_values)
	else:
		target.callv(method_name, argument_values)

func search(query: String) -> Array:
	if query in name.capitalize().to_lower():
		return [self]
	return []

func get_arguments() -> Array:
	return arguments

func reset_arguments() -> void:
	for argument in arguments:
		argument.reset_to_default_value()
