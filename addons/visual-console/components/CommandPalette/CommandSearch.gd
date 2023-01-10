extends LineEdit

onready var placeholder : Label = $Placeholder

func on_focus_entered() -> void:
	placeholder.visible = false

func on_focus_exited() -> void:
	placeholder.visible = len(text) == 0
