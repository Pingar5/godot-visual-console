extends Reference
class_name ConsoleMultiTarget

var targets: Array

func _init(targets: Array) -> void:
	for target in targets:
		self.targets.append(weakref(target))

func get_targets() -> Array:
	var strong_targets: Array = []
	
	var i = 0
	while i < len(targets):
		var strong_target: Object = targets[i].get_ref()
		if strong_target == null:
			targets.remove(i)
		else:
			strong_targets.append(strong_target)
			i += 1
	
	return strong_targets
