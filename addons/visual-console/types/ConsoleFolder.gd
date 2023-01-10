extends ConsoleListing
class_name ConsoleFolder

var containing_folder: ConsoleListing
var listings := {}

func _init(name, containing_folder: ConsoleListing).(name) -> void:
	self.containing_folder = containing_folder

func add_command(path: Array, command: ConsoleCommand) -> void:
	if len(path) == 0:
		listings[command.name] = command
	else:
		var folder_name: String = path.pop_front()
		if not listings.has(folder_name):
			listings[folder_name] = get_script().new(folder_name, self)
		
		if listings[folder_name].has_method("add_command"):
			listings[folder_name].add_command(path, command)
		else:
			Console.write_error("Target console listing %s cannot store commands" % folder_name)

func remove_command(path: Array, command_name: String) -> void:
	if len(path) == 0:
		listings.erase(command_name)
	else:
		var folder_name: String = path.pop_front()
		
		if listings.has(folder_name):
			if listings[folder_name].has_method("remove_command"):
				listings[folder_name].remove_command(path, command_name)
				
				if listings[folder_name].listings.empty():
					listings.erase(folder_name)
			else:
				Console.write_error("Target console listing %s cannot store commands" % folder_name)
		else:
			Console.write_error("Tried to remove command from non-existant folder %s" % folder_name)

func search(query: String) -> Array:
	var results := []
	
	if query in name.capitalize().to_lower():
		results.append(self)
	
	for listing_name in listings:
		results.append_array(listings[listing_name].search(query))
	
	return results

func matches_search(query: String) -> bool:
	for listing_name in listings:
		if listings[listing_name].matches_search(query):
			return true
	return false

func _to_string() -> String:
	var string := ""
	if name != "root":
		string += name + ": ["
	
	for listing in listings.values():
		string += str(listing) + ", "
	
	if name != "root":
		string += "]"
	return string
