extends Reference
class_name ConsoleTarget

var name: String
var target: WeakRef
var tags: Array

func _init(name: String, target: Object, tags: Array) -> void:
	self.name = name
	self.target = weakref(target)
	self.tags = tags
	
	var script_class_name = get_script_class_name(target.get_script().resource_path)
	while script_class_name != "" and not ClassDB.class_exists(script_class_name):
		tags.append(script_class_name)
		script_class_name = get_script_base_class(script_class_name)
	
	var target_class: String = target.get_class()
	while target_class != "Object":
		tags.append(target_class)
		target_class = ClassDB.get_parent_class(target_class)

func has_tag(tag: String) -> bool:
	return tag in tags

func get_target() -> Node:
	return target.get_ref()

func get_script_class_name(script_path : String) -> String:
	var scripts : Array = ProjectSettings.get_setting("_global_script_classes")
	
	for script in scripts:
		if script["path"] == script_path:
			return script["class"]
	return ""

func get_script_base_class(script_name : String) -> String:
	var scripts : Array = ProjectSettings.get_setting("_global_script_classes")
	
	for script in scripts:
		if script["class"] == script_name:
			return script["base"]
	return ""
