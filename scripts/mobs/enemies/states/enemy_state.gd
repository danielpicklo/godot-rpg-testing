class_name EnemyState extends Node

var enemy : Enemy
var state_machine : EnemyStateMachine

func _ready():
	pass

## When the state is initialized
func Init():
	pass

## When a player enters a state
func EnterState() -> void:
	pass

## When a player exits a state
func ExitState() -> void:
	pass

## Process input events in state
func ProcessState(_delta: float) -> EnemyState:
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> EnemyState:
	return null
