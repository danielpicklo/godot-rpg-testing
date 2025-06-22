class_name State_Stun extends State

@export var speed_multiplier : float = 1.0
var hurtbox : Hurtbox
var direction : Vector2
var next_state : State = null

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var parry: State = $"../Parry"

## When the state is initialized
func Init() -> void:
	player.PlayerDamaged.connect(_PlayerDamaged)
	return

## When a player enters a state
func EnterState() -> void:
	
	var bonus_knockback : float = 0.0
	if player.start_parry == true:
		player.parrying = false
		bonus_knockback = 100.0
	
	player.enemy = hurtbox.get_parent()
	player.UpdateAnimation("stun")
	player.animation_player.animation_finished.connect(_AnimationFinished)
	
	direction = player.global_position.direction_to(hurtbox.global_position)
	player.velocity = direction * (-(player.enemy.knockback + bonus_knockback) / player.knockback_resistance)
	player.SetDirection()
	
	player.MakeInvulnerable(player.invulnerability_window)
	player.effect_player.play("damaged")
	pass

## When a player exits a state
func ExitState() -> void:
	player.enemy = null
	next_state = null
	player.animation_player.animation_finished.disconnect(_AnimationFinished)
	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	return next_state

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> State:
	return null

## Handle input events during state
func HandleInput(_event: InputEvent) -> State:
	return null

func _PlayerDamaged(_hurtbox: Hurtbox) -> void:
	hurtbox = _hurtbox
	state_machine.ChangeState(self)
	pass

func _AnimationFinished(_a: String) -> void:
	next_state = idle
	pass
