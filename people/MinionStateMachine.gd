extends Node2D

class_name MinionStateMachine

const HISTORY_LIMIT = 10

export(NodePath) var animationPath
export(NodePath) var spritePath

var state
var velocity = Vector2.ZERO
var damage
var history = []

onready var animation = get_node(animationPath)
onready var sprite = get_node(spritePath)


func ready():
	animation.connect("animation_finished", self, "_on_FSM_Anim_animation_finished")

	state = get_child(0)
	state.fsm = self
	state.enter_state([])
	
	
func change_state(newStateName, args):
	updateHistory(newStateName, args)
	state.exit_state()
	state = get_node(newStateName)
	state.fsm = self
	state.enter_state(args)


func updateHistory(stateName, args):
	if history.size() > HISTORY_LIMIT:
		history.pop_back()

	history.push_front({
		"state": stateName,
		"args": args
	})


func getPreviousState():
	if history.size() > 1:
		return history[1]

	return null
	
	
func enter_state(args):
	pass
	
	
func process(delta):
	pass
	
	
func physics_process(delta):
	pass
	

func animation_finished(anim_name):
	pass
	

func exit_state():
	pass


func _on_FSM_Anim_animation_finished(anim_name):
	state.animation_finished(anim_name)
