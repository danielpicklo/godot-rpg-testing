class_name Enemy extends CharacterBody2D

signal DirectionChanged(new_direction: Vector2)
signal EnemyDamaged(hurtbox: Hurtbox)
signal EnemyDestroyed(hurtbox: Hurtbox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var cardinal_direction : Vector2 = Vector2.DOWN
var move_direction : Vector2 = Vector2.ZERO
var player : Player

@export_category("Enemy Attributes")
@export var health : int = 5
@export var invulnerable : bool = false
@export var parry_resistant : bool = false
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
	pass

func _process(_delta):
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection(_new_direction: Vector2) -> bool:
	move_direction = _new_direction
	if move_direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round( (move_direction).angle() / TAU * DIR_4.size() ))
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

func _TakeDamage(hurtbox: Hurtbox) -> void:
	if invulnerable == true:
		return
	
	var bonus_damage : int = 0
	if player.parrying == true:
		bonus_damage = 5
	
	health -= (hurtbox.damage + bonus_damage)
	if health > 0:
		EnemyDamaged.emit(hurtbox)
	else:
		EnemyDestroyed.emit(hurtbox)
