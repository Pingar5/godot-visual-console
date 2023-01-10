extends Control

signal listing_selected(listing)

onready var listings_tree: Tree = $VBoxContainer/Listings
onready var search_bar: LineEdit = $VBoxContainer/SearchBar

var listings_root : TreeItem
var is_filtered: bool = false
var search_query: String = ""
var previous_selection: TreeItem

func _ready() -> void:
	Console.connect("command_list_changed", self, "refresh_display")

func clear_display() -> void:
	listings_tree.clear()
	previous_selection = null
	listings_root = listings_tree.create_item()

func display_listing(listing: ConsoleListing, parent_tree_item: TreeItem) -> void:
	var item := listings_tree.create_item(parent_tree_item)
	item.set_text(0, listing.name.capitalize())
	item.set_tooltip(0, " ")
	item.set_metadata(0, listing)
	
	if listing is ConsoleFolder:
		item.collapsed = true
		item.set_custom_bg_color(0, listings_tree.get_color("folder_color"))
		
		var sub_listings: Array = listing.listings.values()
		sub_listings.sort_custom(self, "compare_listings")
		
		for sub_listing in sub_listings:
			display_listing(sub_listing, item)

func refresh_display() -> void:
	clear_display()
	
	var listings: Array
	if is_filtered:
		listings = Console.root_folder.search(search_query)
	else:
		listings = Console.root_folder.listings.values()
	
	listings.sort_custom(self, "compare_listings")
	
	for listing in listings:
		display_listing(listing, listings_root)

func on_search_changed(query: String) -> void:
	if query.empty():
		search_query = ""
		is_filtered = false
	else:
		search_query = query.to_lower()
		is_filtered = true
	
	refresh_display()

func focus_search_bar() -> void:
	search_bar.grab_focus()

func clear_search_bar() -> void:
	search_bar.clear()

func on_search_entered(query: String) -> void:
	if query.empty():
		return
	
	var listings : Array = Console.root_folder.search(query)
	listings.sort_custom(self, "compare_listings")
	
	if len(listings) > 0:
		emit_signal("listing_selected", listings[0])

func on_selection_changed() -> void:
	if previous_selection:
		var listing = previous_selection.get_metadata(0)
		if listing is ConsoleFolder:
			previous_selection.set_custom_bg_color(0, listings_tree.get_color("folder_color"))
	
	var selection = listings_tree.get_selected()
	if selection:
		var listing = selection.get_metadata(0)
		if listing is ConsoleFolder:
			selection.set_custom_bg_color(0, listings_tree.get_color("folder_color_selected"))
	
	previous_selection = selection

func on_listing_activated() -> void:
	var item = listings_tree.get_selected()
	var listing = item.get_metadata(0)
	if listing is ConsoleFolder:
		item.collapsed = not item.collapsed
	else:
		emit_signal("listing_selected", listing)

func compare_listings(a: ConsoleListing, b: ConsoleListing) -> bool:
	if is_filtered:
		var a_is_prefix_match = a.name.to_lower().begins_with(search_query)
		var b_is_prefix_match = b.name.to_lower().begins_with(search_query)
		
		if a_is_prefix_match != b_is_prefix_match:
			return a.name.find(search_query) < b.name.find(search_query)
		else:
			return a_is_prefix_match
	else:
		var a_is_folder = a is ConsoleFolder
		var b_is_folder = b is ConsoleFolder
		
		if a_is_folder == b_is_folder:
			return a.name < b.name
		else:
			return a_is_folder


