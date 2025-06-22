class_name State extends Node

static var player : Player
static var state_machine : PlayerStateMachine

func _ready():
	pass

## When a player enters a state
func EnterState() -> void:
	pass

## When a player exits a state
func ExitState() -> void:
	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> State:
	return null

## Handle input events during state
func HandleInput(_event: InputEvent) -> State:
	return null
