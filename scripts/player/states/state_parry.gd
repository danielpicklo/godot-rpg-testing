class_name State_Parry extends State

var active_animation : bool = false

@export var speed_multiplier : float = 0.25
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0
@export var attack_sound : AudioStream

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var effect_player: AnimationPlayer = $"../../Sprite2D/AttackEffect/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Sounds/AudioStreamPlayer2D"
@onready var hurtbox: Hurtbox = $"../../Interactions/Hurtbox"
@onready var hitbox: Hitbox = $"../../Interactions/Hitbox"


@onready var walk : State = $"../Walk"
@onready var idle: State = $"../Idle"

## When the state is initialized
func Init() -> void:
	return

## When a player enters a state
func EnterState() -> void:
	
	# Handle starting parry cycle; most vulnerable here
	player.start_parry = true
	active_animation = true
	
	animation_player.animation_finished.connect(EndAnimation)
	
	# Handle delay before parry effect
	await get_tree().create_timer(player.parry_start_delay).timeout
	player.start_parry = false
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(4.0, 6.25)
	audio.play()
	
	player.MakeInvulnerable(player.parry_window)
	player.parrying = true
	
	if player.parrying == true:
		hitbox.monitoring = false
		hurtbox.monitoring = true
	
	await get_tree().create_timer(player.parry_window).timeout
	player.UpdateAnimation("attack")
	effect_player.play("attack_" + player.AnimationDirection())
	
	pass

## When a player exits a state
func ExitState() -> void:
	await get_tree().create_timer((player.parry_window * 2) + player.parry_start_delay).timeout
	animation_player.animation_finished.disconnect(EndAnimation)
	active_animation = false
	hurtbox.monitoring = false
	hitbox.monitoring = true

	pass

## Process input events in state
func ProcessState(_delta: float) -> State:
	if player.move_direction != Vector2.ZERO && !active_animation:
		return walk
	
	# Slow player down after parrying
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	# Allow player to continue moving while attacking, but slower
	player.velocity = player.move_direction * (player.base_speed * speed_multiplier)
	
	if active_animation == false:
		if player.move_direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

## Handle updates during _physics_process and apply to state
func Physics(_delta: float) -> State:
	return null

## Handle input events during state
func HandleInput(_event: InputEvent) -> State:
	return null
	
func EndAnimation(_newAnimationName: String) -> void:
	active_animation = false
