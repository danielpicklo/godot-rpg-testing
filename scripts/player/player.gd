class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var move_direction : Vector2 = Vector2.ZERO
var look_direction : Vector2 = Vector2.ZERO
var enemy : Enemy
var start_parry : bool = false
var parrying : bool = false
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

signal DirectionChanged(new_direction: Vector2)
signal PlayerDamaged(hurtbox: Hurtbox)

@export var maddy_mode : bool = false
@export var invulnerable : bool = false

@export_category("Player Attributes")
@export var base_speed : float = 100.0
@export var health : int = 10
@export var max_health : int = 100
@export var knockback : float = 100.0
@export var knockback_resistance : float = 1.0
@export var parry_start_delay : float = 0.5
@export var parry_window : float = 0.15
@export var invulnerability_window : float = 0.5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_player: AnimationPlayer = $EffectPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hitbox: Hitbox = $Interactions/Hitbox

func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hitbox.Damaged.connect(_TakeDamage)
	UpdatePlayerHealth(99)
	pass

func _process(_delta: float):
	
	# Handle Maddy Mode (instantaneous regeneration)
	if maddy_mode == true:
		invulnerable = true
		health = 100
	
	# Handle determination of player orientation by mouse position
	look_direction = GetLookDirection()
	
	# Handle player input for movement
	move_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	pass

func _physics_process(_delta: float):
	move_and_slide()

# Get the mouse position and return a Vector2
func GetLookDirection() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - global_position).normalized()

	if abs(to_mouse.x) > abs(to_mouse.y):
		return Vector2.RIGHT if to_mouse.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if to_mouse.y > 0 else Vector2.UP

# Set the player orientation by the mouse position
func	 SetDirection() -> bool:
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

func _TakeDamage(hurtbox: Hurtbox) -> void:
	if invulnerable == true:
		return
	
	# Increase the ammout of damage if we failed the parry
	if(parrying || start_parry):
		print("PARRY FAILED")
		UpdatePlayerHealth(-hurtbox.damage * 2)
		parrying = false
		UpdateAnimation("idle")
	else:
		UpdatePlayerHealth(-hurtbox.damage)
		
	if health > 0:
		PlayerDamaged.emit(hurtbox)
	else:
		PlayerDamaged.emit(hurtbox)
		UpdatePlayerHealth(99)
	pass

func UpdatePlayerHealth(delta: int) -> void:
	#health += clampi(health + delta, 0, max_health)
	health -= delta
	print(health)
	pass

func MakeInvulnerable(_window: float = 1.0) -> void:
	invulnerable = true
	hitbox.monitoring = false
	
	await get_tree().create_timer(_window).timeout
	invulnerable = false
	hitbox.monitoring = true
	pass
