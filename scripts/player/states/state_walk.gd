class_name State_Walk extends State

@export var speed_multiplier : float = 1.0
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"

## When a player enters a state
func EnterState() -> void:
	player.UpdateAnimation("walk")
	pass

## When a player exits a state
func ExitState() -> void:
	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	if player.move_direction == Vector2.ZERO:
		return idle
	
	if attack.active_animation == false:
		player.velocity = player.move_direction * (player.base_speed * speed_multiplier)
		
		if player.SetDirection():
			player.UpdateAnimation("walk")
	
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> State:
	return null

## Handle input events during state
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
