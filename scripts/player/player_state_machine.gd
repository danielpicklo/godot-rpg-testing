class_name PlayerStateMachine extends Node

var states : Array[ State ]
var prev_state : State
var curr_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ChangeState(curr_state.ProcessState(delta))
	pass

## Proess physics
func _physics_process(delta: float) -> void:
	ChangeState(curr_state.Physics(delta))
	pass

## Process inputs
func _unhandled_input(event: InputEvent) -> void:
	ChangeState(curr_state.HandleInput(event))
	pass

func Initialize(_player : Player) -> void:
	states = []
	
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].player = _player
	states[0].state_machine = self
	
	for s in states:
		s.Init()
	
	ChangeState(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState(new_state : State) -> void:
	if new_state == null || new_state == curr_state:
		return
	
	if curr_state:
		print(curr_state)
		curr_state.ExitState()
	
	prev_state = curr_state
	curr_state = new_state
	curr_state.EnterState()
