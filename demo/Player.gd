extends KinematicBody2D

export var speed : float

func _process(delta: float) -> void:
	var movement_vector : Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		movement_vector += Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		movement_vector += Vector2.RIGHT
	
	if Input.is_action_pressed("move_up"):
		movement_vector += Vector2.UP
	elif Input.is_action_pressed("move_down"):
		movement_vector += Vector2.DOWN
	
	if abs(movement_vector.x) > 0:
		$Sprite.flip_h = movement_vector.x < 0
	move_and_slide(movement_vector.normalized() * speed)
