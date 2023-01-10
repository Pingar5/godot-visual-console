extends Panel

enum Pane {
	Navigation,
	Command
}

onready var navigation_pane : Control = $NavigationPane
onready var command_pane : Control = $CommandPane
onready var animation_player: AnimationPlayer = $AnimationPlayer

var command_is_successful : bool

func _ready() -> void:
	Console.connect("opened", self, "on_console_opened")

func on_console_opened() -> void:
	open_navigation(false)
	navigation_pane.clear_search_bar()
	if ConsoleSettings.get_setting("focus_search_bar_on_open"):
		navigation_pane.focus_search_bar()

func set_open_pane(pane_id: int, animate: bool = true) -> void:
	var base_animation_name = "switch_to_command" if pane_id == Pane.Command else "switch_to_navigation"
	animation_player.play(base_animation_name + ("" if animate else "_instant"))

func open_navigation(animate: bool = true) -> void:
	set_open_pane(Pane.Navigation, animate)
	navigation_pane.refresh_display()

func open_command(command: ConsoleCommand, animate: bool = true) -> void:
	set_open_pane(Pane.Command, animate)
	command_pane.display_command(command)

func on_listing_selected(listing: ConsoleListing) -> void:
	if listing is ConsoleCommand:
		if Input.is_action_pressed("console_skip_arguments"):
			if ConsoleSettings.get_setting("shift_execute_behavior") == ConsoleSettings.ShiftExecuteBehavior.RESET_ARGUMENTS:
				listing.reset_arguments()
			
			execute_command(listing)
		elif listing.should_execute_immediately():
			execute_command(listing)
		else:
			open_command(listing)

func execute_command(command: ConsoleCommand) -> void:
	command_is_successful = true
	command.execute()
	
	if command_is_successful and ConsoleSettings.get_setting("close_console_after_successful_command"):
		Console.close()

func on_command_cancelled() -> void:
	set_open_pane(Pane.Navigation)

