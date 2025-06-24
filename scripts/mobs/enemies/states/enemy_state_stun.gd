class_name EnemyStateStun extends EnemyState

@export var anim_name : String = "stun"
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState

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
	
	var knockback_bonus : float = 0.0
	if enemy.player.parrying == true && !enemy.parry_resistant:
		knockback_bonus = 50.0
	
	_animation_finished = false
	enemy.invulnerable = true
	enemy.is_targetting = false
	var _rand = randi_range(0, 3)
	
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * ((-enemy.player.knockback + knockback_bonus) / enemy.knockback_resistance)
	
	enemy.UpdateAnimation(anim_name)
	enemy.animation_player.animation_finished	.connect(_OnAnimationFinished)
	pass

## When a player exits a state
func ExitState() -> void:
	enemy.invulnerable = false
	enemy.is_targetting = true
	enemy.animation_player.animation_finished.disconnect(_OnAnimationFinished)
	pass

## Process input events in state
func ProcessState(_delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> EnemyState:
	return null

## Handle when the enemy is damaged
func _OnEnemyDamaged(hurtbox: Hurtbox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.ChangeState(self)

func _OnAnimationFinished(_a : String) -> void:
	_animation_finished = true
