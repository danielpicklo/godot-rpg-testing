class_name State_Sprint extends State

@export var speed_multiplier : float = 2.0
@export var anim_name : String = "walk"

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var sprint: State = $"../Sprint"
@onready var walk: State = $"../Walk"
@onready var parry: State = $"../Parry"

## When the state is initialized
func Init() -> void:
	return

## When a player enters a state
func EnterState() -> void:
	player.UpdateAnimation(anim_name)
	player.is_sprinting = true
	pass

## When a player exits a state
func ExitState() -> void:
	print("not sprinting")
	player.is_sprinting = false
	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	if player.move_direction == Vector2.ZERO:
		return idle
	
	if attack.active_animation == false:
		player.velocity = player.move_direction * (player.base_speed * speed_multiplier)
		
		if player.SetDirection():
			player.UpdateAnimation(anim_name)
	
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> State:
	return null

## Handle input events during state
func HandleInput(_event: InputEvent) -> State:
	print("handle input sprint")
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("parry"):
		return parry
	elif _event.is_action("sprint"):
		return sprint
	else:
		return idle
	return null
