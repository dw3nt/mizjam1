extends Node2D

class_name MinionStateMachine

export(NodePath) var animationPath

var state

onready var animation = get_node(animationPath)


func ready():
	state = get_child(0)
	state.fsm = self
	state.enter_state()
	
	
func change_state(newStateName):
	state.exit_state()
	state = get_node(newStateName)
	state.fsm = self
	state.enter_state()
	
	
func enter_state():
	pass
	
	
func process(delta):
	pass
	
	
func physics_process(delta):
	pass
	
	
func input(event):
	pass
	
	
func animation_finished(anim_name):
	pass
	
	
func exit_state():
	pass
