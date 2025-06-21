class_name EnemyStateMachine extends Node

var states : Array[EnemyState]
var prev_state : EnemyState
var curr_state : EnemyState

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta):
	ChangeState(curr_state.ProcessState(_delta))
	pass

func _physics_process(delta: float) -> void:
	ChangeState(curr_state.Physics(delta))
	pass

func Initialize(_enemy: Enemy) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append(c)
	
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.Init()
	
	if states.size() > 0:
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
		
	pass

func ChangeState(new_state: EnemyState) -> void:
	if new_state == null || new_state == curr_state:
		return
	
	if curr_state:
		curr_state.ExitState()
	
	prev_state = curr_state
	curr_state = new_state
	curr_state.EnterState()
