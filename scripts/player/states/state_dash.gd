class_name State_Dash extends State

@export var speed_multiplier : float = 2.0
@export var anim_name : String = "walk"

@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var dash: State = $"../Dash"
@onready var walk: State = $"../Walk"
@onready var parry: State = $"../Parry"

## When the state is initialized
func Init() -> void:
	return

## When a player enters a state
func EnterState() -> void:
	player.UpdateAnimation(anim_name)
	player.is_dashing = true
	pass

## When a player exits a state
func ExitState() -> void:
	player.is_dashing = false
	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	if player.move_direction == Vector2.ZERO:
		return idle
	
	if attack.active_animation == false:
		player.velocity += player.move_direction * (player.base_speed * speed_multiplier)# * decelerate_speed * _delta
		
		if player.SetDirection():
			player.UpdateAnimation(anim_name)
	
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
	elif _event.is_action_pressed("dash"):
		return dash
	else:
		return idle
	return null
