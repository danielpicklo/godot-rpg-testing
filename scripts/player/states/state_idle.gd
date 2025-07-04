class_name State_Idle extends State

@export var speed_multiplier : float = 1.0

@onready var walk : State = $"../Walk"
@onready var sprint : State = $"../Sprint"
@onready var attack: State = $"../Attack"
@onready var parry: State_Parry = $"../Parry"

## When the state is initialized
func Init() -> void:
	return

## When a player enters a state
func EnterState() -> void:
	player.UpdateAnimation("idle")
	player.is_sprinting = false
	pass

## When a player exits a state
func ExitState() -> void:
	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	if player.move_direction != Vector2.ZERO:
		if player.is_sprinting == false:
			return walk
		else:
			return sprint
	player.velocity = Vector2.ZERO
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> State:
	return null

## Handle input events during state
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("parry"):
		return parry
	return null
