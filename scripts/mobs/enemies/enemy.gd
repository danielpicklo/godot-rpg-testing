class_name Enemy extends CharacterBody2D

signal DirectionChanged(new_direction: Vector2)
signal EnemyDamaged(hurtbox: Hurtbox)
signal EnemyDestroyed(hurtbox: Hurtbox)
signal EnemyStaggered(hitbox: Hitbox)
signal EnemyStaggerDestroyed(hitbox: Hitbox)


const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var cardinal_direction : Vector2 = Vector2.DOWN
var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO
var player : Player

# Targetting & Pathing System
var is_targetting : bool = false
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@export_category("Enemy Attributes")
@export var health : int = 5
@export var speed : float = 50.0
@export var invulnerable : bool = false
@export var parry_resistant : bool = false
@export var neutral : bool = false
@export var knockback : float = 5.0
@export var knockback_resistance : float = 0.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $StateMachine
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox

func _ready():
	state_machine.Initialize(self)
	player = PlayerManager.player
	hitbox.Damaged.connect(_TakeDamage)
	hitbox.Staggered.connect(_Stagger)
	
	# If the mob is not neutral by default, have it immediately start trying to target the player
	if !neutral:
		is_targetting = true
	pass

func _process(_delta):
	if !is_targetting:
		look_direction = move_direction
	else:
		look_direction = GetLookDirection()
	pass

func _physics_process(_delta: float) -> void:
	if is_targetting == true:
		nav_agent.target_position = player.global_position
		var current_agent_position = global_position
		var next_path_position = nav_agent.get_next_path_position()
		velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()

func _OnNavAgentVelocityComputed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	pass

# Get the player position and return a Vector2
func GetLookDirection() -> Vector2:
	var player_position = player.global_position
	var to_player_position = (player_position - global_position).normalized()

	if abs(to_player_position.x) > abs(to_player_position.y):
		return Vector2.RIGHT if to_player_position.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if to_player_position.y > 0 else Vector2.UP

func SetDirection(_new_direction: Vector2) -> bool:
	
	if !is_targetting:
		look_direction = _new_direction
		
	if look_direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round( (look_direction).angle() / TAU * DIR_4.size() ))
	var new_direction = DIR_4[direction_id]
	
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	DirectionChanged.emit(new_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimationDirection())
	pass

func AnimationDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "front"
	elif cardinal_direction == Vector2.UP:
		return "back"
	else:
		return "side"

func _TakeDamage(_hurtbox: Hurtbox) -> void:
	if invulnerable == true:
		return
	
	health -= (_hurtbox.damage)
	if health > 0:
		EnemyDamaged.emit(_hurtbox)
	else:
		EnemyDestroyed.emit(_hurtbox)

func _Stagger(_hitbox: Hitbox) -> void:
	
	var bonus_damage : int = 1
	if !parry_resistant:
		health -= 5 * bonus_damage
		if health > 0:
			EnemyStaggered.emit(_hitbox)
		else:
			EnemyStaggerDestroyed.emit(_hitbox)
