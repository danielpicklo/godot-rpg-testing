class_name EnemyStateIdle extends EnemyState

@export var anim_name : String = "idle"
@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var next_state : EnemyState

var _timer : float = 0.0


func _ready():
	pass

## When the state is initialized
func Init():
	pass

## When a player enters a state
func EnterState() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
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
