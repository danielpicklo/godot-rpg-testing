class_name EnemyStateTarget extends EnemyState

@export var anim_name : String = "walk"
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var target_range : float = 100.0
@export var target_speed : float = 25.0

@export var next_state : EnemyState
@export var stun_state : EnemyState

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false

func _ready():
	pass

## When the state is initialized
func Init():
	enemy.EnemyDamaged.connect(_OnEnemyDamaged)
	pass

## When a player enters a state
func EnterState() -> void:
	if !enemy.neutral:
		print("not neutral")
		target_range == 1000.0
	
	await get_tree().create_timer(0.2).timeout
	enemy.is_targetting = true
	_direction = enemy.look_direction
	pass

## When a player exits a state
func ExitState() -> void:
	#enemy.animation_player.animation_finished.disconnect(_OnAnimationFinished)
	pass

## Process input events in state
func ProcessState(_delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> EnemyState:
	var target_location = enemy.player.global_position - enemy.global_position
	if target_location.length() < target_range:
		print("target_location", target_location.length())
		enemy.is_targetting = true
		enemy.SetDirection(_direction)
		enemy.UpdateAnimation(anim_name)
	else:
		enemy.is_targetting = false
		state_machine.ChangeState(next_state)
	
	return null

## Handle when the enemy is damaged
func _OnEnemyDamaged(hurtbox: Hurtbox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.ChangeState(stun_state)

func _OnAnimationFinished(_a : String) -> void:
	_animation_finished = true
