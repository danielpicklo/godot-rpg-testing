class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var base_speed : float = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

signal DirectionChanged(new_direction: Vector2)

func _ready():
	state_machine.Initialize(self)
	pass

func _process(delta: float):
	
	look_direction = GetLookDirection()
	
	## Handle player input for movement
	move_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	pass

func _physics_process(delta: float):
	move_and_slide()

func GetLookDirection() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - global_position).normalized()

	if abs(to_mouse.x) > abs(to_mouse.y):
		return Vector2.RIGHT if to_mouse.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if to_mouse.y > 0 else Vector2.UP

func	 SetDirection() -> bool:
	if look_direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round( (look_direction).angle() / TAU * DIR_4.size() ))
	var new_direction = DIR_4[direction_id]
	
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	DirectionChanged.emit(new_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimationDirection())
	pass
	
func AnimationDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "front"
	elif cardinal_direction == Vector2.UP:
		return "back"
	else:
		return "side"
