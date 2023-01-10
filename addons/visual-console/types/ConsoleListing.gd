extends Reference
class_name ConsoleListing

var name: String

func _init(name : String) -> void:
	self.name = name

func search(query: String) -> Array:
	return []

func matches_search(query: String) -> bool:
	return query in name.capitalize().to_lower()

func _to_string() -> String:
	return name
