class_name EnemyStateWander extends EnemyState

@export var anim_name : String = "walk"
@export var wander_speed : float = 20.0

@export_category("AI")
@export var state_animation_duration : float = 1.2
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 5
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2

func _ready():
	pass

## When the state is initialized
func Init():
	pass

## When a player enters a state
func EnterState() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]
	
	enemy.velocity = _direction * wander_speed
	enemy.SetDirection(_direction)
	enemy.UpdateAnimation(anim_name)
	pass

## When a player exits a state
func ExitState() -> void:
	pass

## Process input events in state
func ProcessState(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> EnemyState:
	return null
