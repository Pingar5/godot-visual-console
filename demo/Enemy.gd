extends KinematicBody2D

enum Directions { UP, DOWN, LEFT, RIGHT }
const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

export var select_direction_every : float = 3.0
export var speed : float = 32.0

onready var select_direction_in : float = select_direction_every

var direction : Vector2

func _process(delta: float) -> void:
	select_direction_in -= delta
	if select_direction_in <= 0:
		select_direction()
		select_direction_in = select_direction_every
	
	move_and_slide(direction.normalized() * speed)

func select_direction() -> void:
	direction = DIRECTIONS[randi() % 4]
	$Sprite.flip_h = direction.x < 0
