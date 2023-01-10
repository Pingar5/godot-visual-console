extends Panel

func _ready() -> void:
	$ClickToClose.connect("pressed", get_parent(), "close")
