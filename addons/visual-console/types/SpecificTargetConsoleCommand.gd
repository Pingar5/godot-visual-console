extends ConsoleCommand
class_name SpecificTargetConsoleCommand

var target: WeakRef

func _init(name: String, target: Node, method_name: String, arguments: Array = []).(name, method_name, arguments) -> void:
	self.target = weakref(target)

func get_target() -> Object:
	return target.get_ref()
