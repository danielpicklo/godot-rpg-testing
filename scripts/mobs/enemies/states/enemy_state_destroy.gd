class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var decelerate_speed : float = 10.0

@export_category("AI")

var _damage_position : Vector2
var _direction : Vector2

func _ready():
	pass

## When the state is initialized
func Init():
	enemy.EnemyDestroyed.connect(_OnEnemyDestroyed)
	pass

## When an enemy enters a state
func EnterState() -> void:
	
	enemy.invulnerable = true
	var _rand = randi_range(0, 3)
	
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.SetDirection(Vector2.DOWN)
	enemy.velocity = _direction * (-enemy.player.knockback / enemy.knockback_resistance)
	
	enemy.UpdateAnimation(anim_name)
	enemy.animation_player.animation_finished	.connect(_OnAnimationFinished)
	pass

## When an enemy exits a state
func ExitState() -> void:
	if enemy.player.parrying == true:
		print("death by parry")
	pass

## Process input events in state
func ProcessState(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> EnemyState:
	return null

## Handle when the enemy is damaged
func _OnEnemyDestroyed(hurtbox: Hurtbox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.ChangeState(self)

func _OnAnimationFinished(_a : String) -> void:
	enemy.queue_free()
